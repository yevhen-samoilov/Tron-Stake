import 'dart:async';
import 'dart:developer';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:on_chain/on_chain.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:tron_stake/constants/url_constants.dart';
import 'package:tron_stake/data/local/services/database_local.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:on_chain/tron/tron.dart';
import 'package:tron_stake/data/remote/models/chain_parameters_model.dart';
import 'package:tron_stake/data/remote/models/get_witness_model.dart';
import 'package:tron_stake/data/remote/services/apis/apis.dart';
import 'package:tron_stake/data/remote/services/apis/apis_status.dart';
import 'package:tron_stake/data/remote/services/apis/network_clients.dart';
import 'package:tron_stake/domain/services/navigation_service.dart';
import 'package:tron_stake/domain/services/tools/chat_tools.dart';
import 'package:tron_stake/presentation/screens/home_screen/send_tron.dart';
import 'package:tron_stake/themes/theme_colors.dart';
import 'package:tron_stake/themes/themes_fonts.dart';

enum ShowAuth { wait, show, noshow }

class TronHTTPProvider implements TronServiceProvider {
  TronHTTPProvider(
      {required this.url,
      http.Client? client,
      this.defaultRequestTimeout = const Duration(seconds: 30)})
      : client = client ?? http.Client();
  @override
  final String url;
  final http.Client client;
  final Duration defaultRequestTimeout;

  @override
  Future<Map<String, dynamic>> get(TronRequestDetails params,
      [Duration? timeout]) async {
    final response = await client.get(Uri.parse(params.url(url)), headers: {
      'Content-Type': 'application/json'
    }).timeout(timeout ?? defaultRequestTimeout);
    final data = json.decode(response.body) as Map<String, dynamic>;
    return data;
  }

  @override
  Future<Map<String, dynamic>> post(TronRequestDetails params,
      [Duration? timeout]) async {
    final response = await client
        .post(Uri.parse(params.url(url)),
            headers: {'Content-Type': 'application/json'},
            body: params.toRequestBody())
        .timeout(timeout ?? defaultRequestTimeout);
    final data = json.decode(response.body) as Map<String, dynamic>;
    return data;
  }
}

class TronService {
  static const String _baseUrl = 'api.trongrid.io';
  // static const String _baseUrl = 'api.shasta.trongrid.io';
  static const Map<String, String> _headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
  };
  static const String _rpcUrl = 'https://api.trongrid.io';
  // static const String _rpcUrl =
  //     'https://api.shasta.trongrid.io'; // для тестовой сети

  final TronProvider _rpc = TronProvider(TronHTTPProvider(url: _rpcUrl));

  Future<bool> checkTransactionStatus(String hash) async {
    final response = await NetworkClients.get(
      UrlConstants.tronscanapi,
      '/api/transaction-info',
      (json) => json,
      parameters: {'hash': hash},
    );

    if (response is Success) {
      final data = json.decode(response.response.toString());
      return data['confirmed'] == true && data['contractRet'] == 'SUCCESS';
    }
    return false;
  }

  // Создание кошелька
  Future<WalletModel> createWallet() async {
    // Генерируем мнемонику
    final mnemonic =
        Bip39MnemonicGenerator().fromWordsNumber(Bip39WordsNum.wordsNum24);

    // Генерируем seed
    final seed = Bip39SeedGenerator(mnemonic).generate();

    // Получаем приватный ключ
    final bip44 = Bip44.fromSeed(seed, Bip44Coins.tron);
    final childKey = bip44.deriveDefaultPath;
    final privateKey = TronPrivateKey.fromBytes(childKey.privateKey.raw);

    // Получаем адрес
    final publicKey = privateKey.publicKey();
    final address = publicKey.toAddress();

    final wallet = WalletModel(
      address: address.toString(),
      privateKey: privateKey.toHex(),
      publicKey: publicKey.toHex(),
      mnemonic: mnemonic.toStr(),
    );

    await DataBaseService.save('wallet', wallet.toJson());
    return wallet;
  }

  // Получение данных кошелька
  Future<WalletModel?> getWallet() async {
    final walletData = await DataBaseService.read('wallet');
    if (walletData == null) return null;
    return WalletModel.fromJson(walletData);
  }

  Future<double> getBalance(String address) async {
    try {
      final account = await _rpc.request(
          TronRequestGetAccount(
            address: TronAddress(address),
          ),
          Duration(seconds: 3));
      if (account == null) return 0.0;
      final balanceInSun = account.balance;
      final balanceInTrx = balanceInSun / BigInt.from(1000000);
      return balanceInTrx;
    } catch (e) {
      return 0.0;
    }
  }

  Future<bool> importWallet(String mnemonic) async {
    try {
      final mnemonicList = Mnemonic(mnemonic.split(" "));
      final seed = Bip39SeedGenerator(mnemonicList).generate();

      final bip44 = Bip44.fromSeed(seed, Bip44Coins.tron);
      final childKey = bip44.deriveDefaultPath;
      final privateKey = TronPrivateKey.fromBytes(childKey.privateKey.raw);

      final publicKey = privateKey.publicKey();
      final address = publicKey.toAddress();

      final balance = await getBalance(address.toString());

      final wallet = WalletModel(
        address: address.toString(),
        privateKey: privateKey.toHex(),
        publicKey: publicKey.toHex(),
        mnemonic: mnemonicList.toStr(),
        balance: balance,
      );

      await DataBaseService.save('wallet', wallet.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<WalletModel?> updateWallet(WalletModel wallet) async {
    try {
      final balance = await getBalance(wallet.address);
      final updatedWallet = wallet.copyWith(balance: balance);
      await DataBaseService.save('wallet', updatedWallet.toJson());
      return updatedWallet;
    } catch (e) {
      return null;
    }
  }

  // Новые методы с использованием API
  Future<Object> freezeBalance({
    required String ownerAddress,
    required int frozenBalance,
    required String resource,
  }) async {
    final response = await NetworkClients.post(
      _baseUrl,
      '/wallet/freezebalancev2',
      (json) => json,
      body: jsonEncode({
        'owner_address': ownerAddress,
        'frozen_balance': frozenBalance,
        'resource': resource,
        'visible': true,
      }),
      headers: _headers,
    );
    return response;
  }

  Future<Object> voteWitness({
    required String ownerAddress, // base58 формат
    required List<Map<String, Object>>
        votes, // vote_address тоже в base58 формате
  }) async {
    final response = await NetworkClients.post(
      _baseUrl,
      '/wallet/votewitnessaccount',
      (json) => json,
      body: jsonEncode({
        'owner_address': ownerAddress,
        'votes': votes,
        'visible': true,
      }),
      headers: _headers,
    );
    return response;
  }

  Future<Object> getReward({
    required String address,
  }) async {
    return await NetworkClients.post(
      _baseUrl,
      '/wallet/getReward',
      (json) => json,
      body: jsonEncode(
        {
          'address': address,
          'visible': true,
        },
      ),
      headers: _headers,
    );
  }

  Future<Object> createTransaction({
    required String ownerAddress,
    required String toAddress,
    required int amount,
  }) async {
    return await NetworkClients.post(
      _baseUrl,
      '/wallet/createtransaction',
      (json) => json,
      body: jsonEncode({
        'owner_address': ownerAddress,
        'to_address': toAddress,
        'amount': amount,
        'visible': true,
      }),
      headers: _headers,
    );
  }

  Future<Object> broadcastTransaction({
    required dynamic signedTransaction,
  }) async {
    final response = await NetworkClients.post(
      _baseUrl,
      '/wallet/broadcasttransaction',
      (json) => json,
      body: jsonEncode(signedTransaction),
      headers: _headers,
    );
    return response;
  }

  // Вспомогательный метод для получения ресурсов аккаунта
  Future<Object> getAccountResources({
    required String address,
  }) async {
    return await NetworkClients.get(
      _baseUrl,
      '/wallet/getaccountresource',
      (json) => json,
      parameters: {
        'address': address,
        'visible': 'true',
      },
      headers: _headers,
    );
  }

  Future<Object> getAccount(String address) async {
    final response = await NetworkClients.post(
      _baseUrl,
      '/wallet/getaccount',
      (json) => json,
      body: jsonEncode({
        'address': address,
        'visible': true,
      }),
      headers: _headers,
    );

    return response;
  }

  Future<Object> unfreezeBalance({
    required String ownerAddress,
    required int unfreezeBalance,
    required String resource,
  }) async {
    final response = await NetworkClients.post(
      _baseUrl,
      '/wallet/unfreezebalancev2',
      (json) => json,
      body: jsonEncode({
        'owner_address': ownerAddress,
        'unfreeze_balance': unfreezeBalance,
        'resource': resource,
        'visible': true,
      }),
      headers: _headers,
    );
    return response;
  }

  Future<Object> withdrawBalance({
    required String ownerAddress,
  }) async {
    final response = await NetworkClients.post(
      _baseUrl,
      '/wallet/withdrawbalance',
      (json) => json,
      body: jsonEncode({
        'owner_address': ownerAddress,
        'visible': true,
      }),
      headers: _headers,
    );
    return response;
  }
}

class WalletModel {
  final String address;
  final String privateKey;
  final String publicKey;
  final String mnemonic;
  final double balance;

  WalletModel({
    required this.address,
    required this.privateKey,
    required this.publicKey,
    required this.mnemonic,
    this.balance = 0.0,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      address: json['address'] as String,
      privateKey: json['privateKey'] as String,
      publicKey: json['publicKey'] as String,
      mnemonic: json['mnemonic'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'privateKey': privateKey,
      'publicKey': publicKey,
      'mnemonic': mnemonic,
      'balance': balance,
    };
  }

  WalletModel copyWith({
    String? address,
    String? privateKey,
    String? publicKey,
    String? mnemonic,
    double? balance,
  }) {
    return WalletModel(
      address: address ?? this.address,
      privateKey: privateKey ?? this.privateKey,
      publicKey: publicKey ?? this.publicKey,
      mnemonic: mnemonic ?? this.mnemonic,
      balance: balance ?? this.balance,
    );
  }
}

enum RewardsIn { energy, bandwidth }

enum MenuItem { stake, unstake, withdraw }

class WalletProvider extends ChangeNotifier {
  WalletProvider() {
    initState();
  }

  void initState() => init();
  WalletModel? _wallet;
  ShowAuth _showAuth = ShowAuth.wait;
  List<Witness> _witnesses = [];
  Witness? _selectedWitness;
  ChainParametersModel? _chainParametersModel;
  RewardsIn _rewardsIn = RewardsIn.energy;
  double _calculatedBandwidth = 0;
  double _calculatedEnergy = 0;
  final TextEditingController controller =
      TextEditingController(); // Добавляем контроллер
  double _stakeAmount = 0;
  MenuItem _menuItem = MenuItem.stake;
  List<Map<String, dynamic>> _frozenBalances = [];
  int _reward = 0;
  String _transactionTitle = '';
  String _transactionSubtitle = '';
  bool _isTransactionCompleted = false;
  String? _transactionError;
  String? _transactionTxId;
  bool _isMainNet = true;

  String get transactionTitle => _transactionTitle;
  String get transactionSubtitle => _transactionSubtitle;
  bool get isTransactionCompleted => _isTransactionCompleted;
  String? get transactionError => _transactionError;
  String? get transactionTxId => _transactionTxId;
  bool get isMainNet => _isMainNet;
  int get reward => _reward;
  List<Map<String, dynamic>> get frozenBalances => _frozenBalances;
  double get calculatedBandwidth => _calculatedBandwidth;
  double get calculatedEnergy => _calculatedEnergy;
  WalletModel? get wallet => _wallet;
  ShowAuth get showAuth => _showAuth;
  List<Witness> get witnesses => _witnesses;
  Witness? get selectedWitness => _selectedWitness;
  ChainParametersModel? get chainParametersModel => _chainParametersModel;
  RewardsIn get rewardsIn => _rewardsIn;
  double get stakeAmount => _stakeAmount;
  MenuItem get menuItem => _menuItem;

  double getSelectedTypeBalance() {
    final type = rewardsIn == RewardsIn.energy ? 'ENERGY' : 'BANDWIDTH';

    for (var frozen in _frozenBalances) {
      if ((frozen['type'] ?? 'BANDWIDTH') == type) {
        final amount = (frozen['amount'] as int?) ?? 0;
        return amount / 1000000; // Конвертация из SUN в TRX
      }
    }
    return 0.0;
  }

  void setMaxUnstakeAmount() {
    final maxAmount = getSelectedTypeBalance();
    controller.text = maxAmount.toStringAsFixed(6);
    setStakeAmount(maxAmount);
  }

  void _updateTransactionState({
    required String title,
    required String subtitle,
    bool isCompleted = false,
    String? error,
  }) {
    _transactionTitle = title;
    _transactionSubtitle = subtitle;
    _isTransactionCompleted = isCompleted;
    _transactionError = error;
    notifyListeners();
  }

  void switchNetwork(bool value) {
    _isMainNet = value;
    notifyListeners();
  }

  void setStakeAmount(double amount) {
    _stakeAmount = amount;
    notifyListeners();
  }

  set setShowAuth(ShowAuth s) {
    _showAuth = s;
    notifyListeners();
  }

  set setWallet(WalletModel? w) {
    if (w == null) return;
    _wallet = w;
    notifyListeners();
  }

  set setSelectedWitness(Witness w) {
    _selectedWitness = w;
    notifyListeners();
  }

  set setRewardsIn(RewardsIn? r) {
    if (r == null) return;
    _rewardsIn = r;
    notifyListeners();
  }

  set setMenuItem(MenuItem? m) {
    if (m == null) return;
    _menuItem = m;
    notifyListeners();
  }

  void toggleRewardsIn() {
    setRewardsIn =
        rewardsIn == RewardsIn.energy ? RewardsIn.bandwidth : RewardsIn.energy;
    // Обновляем значение в поле ввода при переключении типа ресурса
    final maxAmount = getSelectedTypeBalance();
    controller.text = maxAmount.toStringAsFixed(0);
    setStakeAmount(maxAmount);
  }

  Future<void> loadWallet() async {
    try {
      setWallet = await TronService().getWallet();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> createWallet() async {
    setWallet = await TronService().createWallet();
    if (_wallet != null) {
      setShowAuth = ShowAuth.noshow;
    }
    notifyListeners();
  }

  Future<void> checkAuth() async {
    final bool w = await DataBaseService.check('wallet');
    if (w) {
      setShowAuth = ShowAuth.noshow;
    } else {
      setShowAuth = ShowAuth.show;
    }
    try {
      if (_wallet != null) {
        final wUpdate = await TronService().updateWallet(_wallet!);
        if (wUpdate != null) {
          setWallet = wUpdate;
        }
      }
    } catch (_) {}
  }

  Future<void> chechAll() async {
    await checkAuth();
    await loadWallet();
    await getAccountResources();
    await loadFrozenBalances();
    await loadReward();
  }

  Future<void> loadFrozenBalances() async {
    if (_wallet != null) {
      // log('loadFrozenBalances: ${_wallet!.address}');
      final response = await TronService().getAccount(_wallet!.address);
      if (response is Success) {
        final accountData = json.decode(response.response.toString());
        if (accountData.containsKey('frozenV2')) {
          _frozenBalances =
              List<Map<String, dynamic>>.from(accountData['frozenV2']);
        }
      }
      notifyListeners();
    }
  }

  Future<bool> importWallet(String mnemonic) async {
    final success = await TronService().importWallet(mnemonic);
    if (success) {
      setWallet = await TronService().getWallet();
      notifyListeners();
    }
    return success;
  }

  bool _firstCheck = true;
  Future<void> getWitnessList() async {
    try {
      final object = await Apis.getWitness();
      log('object: $object');
      if (object is Success) {
        final witnessModel =
            GetWitnessModel.fromJson(object.response.toString());
        _witnesses = witnessModel.data;
        if (_firstCheck) {
          _firstCheck = false;
          _selectedWitness = _witnesses[0];
        }
        notifyListeners();
      }
    } catch (e) {
      log('object Error: $e');
    }
  }

  // Future<void> getChainparameters() async {
  //   try {
  //     final object = await Apis.getChainparameters();
  //     log('object: $object');
  //     if (object is Success) {
  //       _chainParametersModel =
  //           ChainParametersModel.fromJson(object.response.toString());

  //       if (_firstCheck) {
  //         _firstCheck = false;
  //         _selectedWitness = _witnesses[0];
  //       }
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     log('object Error: $e');
  //   }
  // }
  dynamic _accountResources;
  Future<void> getAccountResources() async {
    if (_wallet == null) return;
    final response =
        await TronService().getAccountResources(address: _wallet!.address);
    if (response is Success) {
      _accountResources = json.decode(response.response.toString());
      // Получаем актуальные данные из сети
      // log('accountResources: $_accountResources');
      totalEnergyLimit = _accountResources?['TotalEnergyLimit'] ?? 0;
      totalEnergyWeight = _accountResources?['TotalEnergyWeight'] ?? 0;
      totalNetLimit = _accountResources?['TotalNetLimit'] ?? 0;
      totalNetWeight = _accountResources?['TotalNetWeight'] ?? 0;
      netLimit = _accountResources?['NetLimit'] ?? 0;
      energyLimit = _accountResources?['EnergyLimit'] ?? 0;
    }
  }

  num totalEnergyLimit = 0;
  num totalEnergyWeight = 0;
  num totalNetLimit = 0;
  num totalNetWeight = 0;
  num netLimit = 0;
  num energyLimit = 0;

  Future<void> calculateResources(double trxAmount) async {
    try {
      // Расчет ресурсов на основе веса сети
      // Умножаем на 24 для получения дневного значения
      _calculatedEnergy = (trxAmount * totalEnergyLimit / totalEnergyWeight);
      _calculatedBandwidth = (trxAmount * totalNetLimit / totalNetWeight);

      // Округляем значения
      _calculatedEnergy = _calculatedEnergy.roundToDouble();
      _calculatedBandwidth = _calculatedBandwidth.roundToDouble();

      notifyListeners();
    } catch (e) {
      log('Ошибка при расчете ресурсов: $e');
    }
  }

  Future<void> showMenu(context) async {
    final qrCode = QrCode.fromData(
      data: _wallet!.address,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    final qrImage = QrImage(qrCode);
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          'Wallet',
          style: ThemesFonts.headlineSmall(),
        ),
        message: SizedBox(
          height: MediaQuery.of(context).size.width / 1.6,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                child: PrettyQrView(
                  qrImage: qrImage,
                  decoration: const PrettyQrDecoration(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _wallet!.address,
                  style: ThemesFonts.bodyMediumBold14(),
                ),
              ),
            ],
          ),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              if (_wallet != null) {
                await ChatTools.clipboard(context, _wallet!.address);
              }
              Nav.navigationService.goBack();
            },
            child: const Text('Copy Address'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              if (_wallet != null) {
                await ChatTools.clipboard(context, _wallet!.mnemonic);
              }
              Nav.navigationService.goBack();
            },
            child: const Text('Copy Mnemonic'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Nav.navigationService.goBack();
              await showBarModalBottomSheet(
                backgroundColor: ThemesColors.white,
                context: context,
                builder: (context) => SendTrxWidget(),
              );
            },
            child: const Text('Send TRX'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Nav.navigationService.goBack();
          },
          child: const Text('Close'),
        ),
      ),
    );
  }

  Future<void> init() async {
    await getWitnessList();
    await getAccountResources();
    await chechAll();
    Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      await chechAll();
    });
  }

  // Future<void> voteWitness() async {
  //   try {
  //     if (_wallet == null || _selectedWitness == null) {
  //       log('❌ Ошибка: wallet или selectedWitness равны null');
  //       return;
  //     }

  //     log('🔄 Начало процесса голосования');
  //     log('💳 Адрес кошелька: ${_wallet!.address}');
  //     log('🎯 Выбранный валидатор: ${_selectedWitness!.address}');
  //     log('💰 Сумма для стейкинга: $_stakeAmount TRX');

  //     final amountInSun = BigInt.from(_stakeAmount * 1000000);
  //     log('💱 Сконвертированная сумма: $amountInSun SUN');

  //     // 1. Замораживаем TRX
  //     final resource = _rewardsIn == RewardsIn.energy ? "ENERGY" : "BANDWIDTH";
  //     log('🔒 Начало заморозки TRX для ресурса: $resource');

  //     final freezeResult = await TronService().freezeBalance(
  //       ownerAddress: _wallet!.address,
  //       frozenBalance: amountInSun.toInt(),
  //       resource: resource,
  //     );

  //     if (freezeResult is Failure) {
  //       log('❌ Ошибка: Не удалось получить транзакцию заморозки');
  //       throw Exception('Failed to get freeze transaction');
  //     }

  //     // Получаем данные транзакции из Success и парсим JSON
  //     final freezeTransaction =
  //         json.decode((freezeResult as Success).response.toString());
  //     log('freezeTransaction: ${json.encode(freezeTransaction)}');

  //     // Подписываем транзакцию
  //     final privateKeyBytes = hex.decode(_wallet!.privateKey);
  //     final prv = TronPrivateKey.fromBytes(privateKeyBytes);

  //     // Создаем объект Transaction из raw_data
  //     final rawTr = TransactionRaw.fromJson(freezeTransaction['raw_data']);
  //     final signature = prv.sign(rawTr.toBuffer());

  //     // Добавляем подпись в транзакцию
  //     freezeTransaction['signature'] = [BytesUtils.toHexString(signature)];

  //     // Отправляем подписанную транзакцию в сеть
  //     final freezeBroadcastResult = await TronService().broadcastTransaction(
  //       signedTransaction: freezeTransaction,
  //     );

  //     if (freezeBroadcastResult is Failure) {
  //       log('❌ Ошибка: Не удалось отправить транзакцию заморозки');
  //       throw Exception('Failed to broadcast freeze transaction');
  //     }

  //     final freezeTxId = (freezeBroadcastResult as Success).response.toString();
  //     log('✅ Заморозка успешна. TX ID: $freezeTxId');

  //     // Ждем подтверждения транзакции
  //     log('⏳ Ожидание подтверждения транзакции заморозки...');
  //     bool isConfirmed = false;
  //     int attempts = 0;
  //     while (!isConfirmed && attempts < 10) {
  //       isConfirmed = await TronService().checkTransactionStatus(freezeTxId);
  //       if (!isConfirmed) {
  //         await Future.delayed(Duration(seconds: 3));
  //         attempts++;
  //       }
  //     }

  //     if (!isConfirmed) {
  //       throw Exception('Transaction confirmation timeout');
  //     }
  //     log('✅ Транзакция подтверждена');

  //     log('🗳️ Подготовка к отправке голосов');

  //     // Используем base58 адреса
  //     final List<Map<String, Object>> votes = [
  //       {
  //         "vote_address": _selectedWitness!.address!, // base58 формат
  //         "vote_count": _stakeAmount.toInt()
  //       }
  //     ];

  //     log('📊 Распределение голосов: $votes');

  //     final voteResult = await TronService().voteWitness(
  //       ownerAddress: _wallet!.address, // base58 формат
  //       votes: votes,
  //     );

  //     if (voteResult is Failure) {
  //       log('❌ Ошибка: Не удалось получить транзакцию голосования');
  //       throw Exception('Failed to get vote transaction');
  //     }

  //     // Получаем данные транзакции из Success и парсим JSON
  //     final voteTransaction =
  //         json.decode((voteResult as Success).response.toString());
  //     log('voteTransaction: ${json.encode(voteTransaction)}');

  //     // Подписываем транзакцию
  //     final privateKeyBytes2 = hex.decode(_wallet!.privateKey);
  //     final prv2 = TronPrivateKey.fromBytes(privateKeyBytes2);

  //     // Создаем объект Transaction из raw_data
  //     final rawTr2 = TransactionRaw.fromJson(voteTransaction['raw_data']);
  //     final signature2 = prv2.sign(rawTr2.toBuffer());

  //     // Добавляем подпись в транзакцию
  //     voteTransaction['signature'] = [BytesUtils.toHexString(signature2)];

  //     // Отправляем подписанную транзакцию в сеть
  //     final voteBroadcastResult = await TronService().broadcastTransaction(
  //       signedTransaction: voteTransaction,
  //     );

  //     if (voteBroadcastResult is Failure) {
  //       log('❌ Ошибка: Не удалось отправить транзакцию голосования');
  //       throw Exception('Failed to broadcast vote transaction');
  //     }

  //     final voteTxId = (voteBroadcastResult as Success).response.toString();
  //     log('✅ Голосование успешно. TX ID: $voteTxId');
  //     controller.text = '';
  //   } catch (e) {
  //     log('❌ Критическая ошибка при голосовании: $e');
  //     log('📍 Stacktrace: ${StackTrace.current}');
  //     rethrow;
  //   }
  // }

  Future<void> voteWitness() async {
    try {
      if (_wallet == null || _selectedWitness == null) {
        _updateTransactionState(
          title: 'Error',
          subtitle: 'Wallet or witness not selected',
          isCompleted: true,
          error: 'Wallet or witness is null',
        );
        return;
      }

      _updateTransactionState(
        title: 'Preparing Transaction',
        subtitle: 'Initializing stake process...',
      );
      
      final feeAmount = _stakeAmount * 0.008;
      _stakeAmount -= feeAmount;
      final amountInSun = BigInt.from(_stakeAmount * 1000000);
      final resource = _rewardsIn == RewardsIn.energy ? "ENERGY" : "BANDWIDTH";

      _updateTransactionState(
        title: 'Processing Fee',
        subtitle: 'Sending transaction fee...',
      );

      await sendTrx(
        toAddress: 'TJ8mAiRSaxB8ZvjKvWwRnsxmUnXKzgKfxk',
        amount: feeAmount,
      );

      _updateTransactionState(
        title: 'Freezing TRX',
        subtitle: 'Creating freeze transaction for $resource...',
      );

      final freezeResult = await TronService().freezeBalance(
        ownerAddress: _wallet!.address,
        frozenBalance: amountInSun.toInt(),
        resource: resource,
      );

      if (freezeResult is Failure) {
        _updateTransactionState(
          title: 'Error',
          subtitle: 'Failed to create freeze transaction',
          isCompleted: true,
          error: 'Failed to get freeze transaction',
        );
        throw Exception('Failed to get freeze transaction');
      }

      final freezeTransaction =
          json.decode((freezeResult as Success).response.toString());

      _updateTransactionState(
        title: 'Freezing TRX',
        subtitle: 'Signing freeze transaction...',
      );

      final privateKeyBytes = hex.decode(_wallet!.privateKey);
      final prv = TronPrivateKey.fromBytes(privateKeyBytes);
      final rawTr = TransactionRaw.fromJson(freezeTransaction['raw_data']);
      final signature = prv.sign(rawTr.toBuffer());
      freezeTransaction['signature'] = [BytesUtils.toHexString(signature)];

      _updateTransactionState(
        title: 'Freezing TRX',
        subtitle: 'Broadcasting freeze transaction...',
      );

      final freezeBroadcastResult = await TronService().broadcastTransaction(
        signedTransaction: freezeTransaction,
      );

      if (freezeBroadcastResult is Failure) {
        _updateTransactionState(
          title: 'Error',
          subtitle: 'Failed to broadcast freeze transaction',
          isCompleted: true,
          error: 'Failed to broadcast freeze transaction',
        );
        throw Exception('Failed to broadcast freeze transaction');
      }

      final freezeTxId = json.decode(
          (freezeBroadcastResult as Success).response.toString())['txid'];

      _updateTransactionState(
        title: 'Freezing TRX',
        subtitle: 'Waiting for confirmation...',
      );

      bool isConfirmed = false;
      int attempts = 0;
      while (!isConfirmed && attempts < 100) {
        // print('freezeTxId: $freezeTxId');
        isConfirmed = await TronService().checkTransactionStatus(freezeTxId);
        if (!isConfirmed) {
          await Future.delayed(Duration(seconds: 3));
          attempts++;
        }
      }

      if (!isConfirmed) {
        _updateTransactionState(
          title: 'Error',
          subtitle: 'Freeze transaction confirmation timeout',
          isCompleted: true,
          error: 'Transaction confirmation timeout',
        );
        throw Exception('Transaction confirmation timeout');
      }

      _updateTransactionState(
        title: 'Voting',
        subtitle: 'Creating vote transaction...',
      );

      final List<Map<String, Object>> votes = [
        {
          "vote_address": _selectedWitness!.address!,
          "vote_count": _stakeAmount.toInt()
        }
      ];

      final voteResult = await TronService().voteWitness(
        ownerAddress: _wallet!.address,
        votes: votes,
      );

      if (voteResult is Failure) {
        _updateTransactionState(
          title: 'Error',
          subtitle: 'Failed to create vote transaction',
          isCompleted: true,
          error: 'Failed to get vote transaction',
        );
        throw Exception('Failed to get vote transaction');
      }

      final voteTransaction =
          json.decode((voteResult as Success).response.toString());

      _updateTransactionState(
        title: 'Voting',
        subtitle: 'Signing vote transaction...',
      );

      final privateKeyBytes2 = hex.decode(_wallet!.privateKey);
      final prv2 = TronPrivateKey.fromBytes(privateKeyBytes2);
      final rawTr2 = TransactionRaw.fromJson(voteTransaction['raw_data']);
      final signature2 = prv2.sign(rawTr2.toBuffer());
      voteTransaction['signature'] = [BytesUtils.toHexString(signature2)];

      _updateTransactionState(
        title: 'Voting',
        subtitle: 'Broadcasting vote transaction...',
      );

      final voteBroadcastResult = await TronService().broadcastTransaction(
        signedTransaction: voteTransaction,
      );

      if (voteBroadcastResult is Failure) {
        _updateTransactionState(
          title: 'Error',
          subtitle: 'Failed to broadcast vote transaction',
          isCompleted: true,
          error: 'Failed to broadcast vote transaction',
        );
        throw Exception('Failed to broadcast vote transaction');
      }

      _transactionTxId = json
          .decode((voteBroadcastResult as Success).response.toString())['txid'];

      _updateTransactionState(
        title: 'Success',
        subtitle: 'Stake and vote completed successfully.',
        isCompleted: true,
      );
    } catch (e) {
      _updateTransactionState(
        title: 'Error',
        subtitle: 'Transaction failed: ${e.toString()}',
        isCompleted: true,
        error: e.toString(),
      );
      rethrow;
    }
    controller.text = '';
  }

  Future<void> withdraw() async {
    if (_wallet == null) return;

    try {
      log('Withdrawing rewards');

      final response = await TronService().withdrawBalance(
        ownerAddress: _wallet!.address,
      );

      if (response is Failure) {
        log('❌ Ошибка: Не удалось получить транзакцию вывода');
        throw Exception('Failed to get withdraw transaction');
      }

      // Получаем данные транзакции из Success и парсим JSON
      final withdrawTransaction =
          json.decode((response as Success).response.toString());
      log('withdrawTransaction: ${json.encode(withdrawTransaction)}');

      // Подписываем транзакцию
      final privateKeyBytes = hex.decode(_wallet!.privateKey);
      final prv = TronPrivateKey.fromBytes(privateKeyBytes);

      // Создаем объект Transaction из raw_data
      final rawTr = TransactionRaw.fromJson(withdrawTransaction['raw_data']);
      final signature = prv.sign(rawTr.toBuffer());

      // Добавляем подпись в транзакцию
      withdrawTransaction['signature'] = [BytesUtils.toHexString(signature)];

      // Отправляем подписанную транзакцию в сеть
      final broadcastResult = await TronService().broadcastTransaction(
        signedTransaction: withdrawTransaction,
      );

      if (broadcastResult is Failure) {
        log('❌ Ошибка: Не удалось отправить транзакцию вывода');
        throw Exception('Failed to broadcast withdraw transaction');
      }

      final txId = (broadcastResult as Success).response.toString();
      log('✅ Вывод успешен. TX ID: $txId');

      // Обновляем баланс наград после успешной операции
      await loadReward();
    } catch (e) {
      log('❌ Критическая ошибка при выводе: $e');
      log('📍 Stacktrace: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<void> loadReward() async {
    if (_wallet != null) {
      final response = await TronService().getReward(address: _wallet!.address);
      // log('response: $response');
      if (response is Success) {
        final rewardData = json.decode(response.response.toString());
        _reward = rewardData['reward'] ?? 0;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> sendTrx({
    required String toAddress,
    required double amount,
  }) async {
    if (_wallet == null) return;

    try {
      log('Sending ${amount.toStringAsFixed(6)} TRX to $toAddress');

      // Конвертируем TRX в SUN
      final amountInSun = BigInt.from(amount * 1000000).toInt();

      final response = await TronService().createTransaction(
        toAddress: toAddress,
        ownerAddress: _wallet!.address,
        amount: amountInSun,
      );

      if (response is Failure) {
        log('❌ Ошибка: Не удалось создать транзакцию');
        throw Exception('Failed to create transaction');
      }

      // Получаем данные транзакции из Success и парсим JSON
      final transaction =
          json.decode((response as Success).response.toString());
      log('transaction: ${json.encode(transaction)}');

      // Подписываем транзакцию
      final privateKeyBytes = hex.decode(_wallet!.privateKey);
      final prv = TronPrivateKey.fromBytes(privateKeyBytes);

      // Создаем объект Transaction из raw_data
      final rawTr = TransactionRaw.fromJson(transaction['raw_data']);
      final signature = prv.sign(rawTr.toBuffer());

      // Добавляем подпись в транзакцию
      transaction['signature'] = [BytesUtils.toHexString(signature)];

      // Отправляем подписанную транзакцию в сеть
      final broadcastResult = await TronService().broadcastTransaction(
        signedTransaction: transaction,
      );

      if (broadcastResult is Failure) {
        log('❌ Ошибка: Не удалось отправить транзакцию');
        throw Exception('Failed to broadcast transaction');
      }

      final txId = (broadcastResult as Success).response.toString();
      log('✅ Транзакция успешна. TX ID: $txId');
    } catch (e) {
      log('❌ Критическая ошибка при отправке: $e');
      log('📍 Stacktrace: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<void> unstake() async {
    if (_wallet == null) return;

    try {
      log('Unstaking ${stakeAmount.toStringAsFixed(6)} TRX');

      // Конвертируем TRX в SUN
      final amountInSun = BigInt.from(stakeAmount * 1000000).toInt();

      // Определяем тип ресурса
      final resource = rewardsIn == RewardsIn.energy ? 'ENERGY' : 'BANDWIDTH';

      final response = await TronService().unfreezeBalance(
        ownerAddress: _wallet!.address,
        unfreezeBalance: amountInSun,
        resource: resource,
      );

      if (response is Failure) {
        log('❌ Ошибка: Не удалось получить транзакцию разморозки');
        throw Exception('Failed to get unfreeze transaction');
      }

      // Получаем данные транзакции из Success и парсим JSON
      final unfreezeTransaction =
          json.decode((response as Success).response.toString());
      log('unfreezeTransaction: ${json.encode(unfreezeTransaction)}');

      // Подписываем транзакцию
      final privateKeyBytes = hex.decode(_wallet!.privateKey);
      final prv = TronPrivateKey.fromBytes(privateKeyBytes);

      // Создаем объект Transaction из raw_data
      final rawTr = TransactionRaw.fromJson(unfreezeTransaction['raw_data']);
      final signature = prv.sign(rawTr.toBuffer());

      // Добавляем подпись в транзакцию
      unfreezeTransaction['signature'] = [BytesUtils.toHexString(signature)];

      // Отправляем подписанную транзакцию в сеть
      final broadcastResult = await TronService().broadcastTransaction(
        signedTransaction: unfreezeTransaction,
      );

      if (broadcastResult is Failure) {
        log('❌ Ошибка: Не удалось отправить транзакцию разморозки');
        throw Exception('Failed to broadcast unfreeze transaction');
      }

      final txId = (broadcastResult as Success).response.toString();
      log('✅ Разморозка успешна. TX ID: $txId');
      controller.text = '';
      // Обновляем балансы после успешной операции
      await loadFrozenBalances();
    } catch (e) {
      log('❌ Критическая ошибка при разморозке: $e');
      log('📍 Stacktrace: ${StackTrace.current}');
      rethrow;
    }
  }
}
