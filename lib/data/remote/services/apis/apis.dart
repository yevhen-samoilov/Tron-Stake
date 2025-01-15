import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:tron_stake/constants/url_constants.dart';
import 'package:tron_stake/data/remote/services/apis/network_clients.dart';
// import 'package:tron_stake/domain/services/tron_service.dart';
// import 'package:http/http.dart';
// import 'package:http_parser/http_parser.dart';

String generateKey() {
  const secretPassphrase = "Samoilov1010";
  final key =
      sha256.convert(utf8.encode(secretPassphrase)).toString().substring(0, 32);
  return key;
}

String tempTokenGenerator() {
  const p = "crypto_encrypt.dart";
  final key = encrypt.Key.fromUtf8(generateKey());
  final iv = encrypt.IV.fromLength(16);
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encryptedPassword = encrypter.encrypt(p, iv: iv);
  final tempToken = "${key.base64}.${iv.base64}.${encryptedPassword.base64}";
  log('token2: $tempToken');
  return tempToken;
}

class Apis {
  static Future<Object> getToken() async {
    final token = tempTokenGenerator();
    Object object = await NetworkClients.get(
        UrlConstants.openAISoft, '/get-token', (json) => json,
        parameters: {
          'token': token
        },
        headers: {
          'Content-Type': 'application/json',
        });
    return object;
  }

  static Future<Object> getWitness() async {
    Object object = await NetworkClients.get(
      UrlConstants.tronscanapi,
      '/api/pagewitness',
      (json) => json,
      parameters: {'witnesstype': '1'},
    );
    return object;
  }

  static Future<Object> getChainparameters() async {
    Object object = await NetworkClients.get(
      UrlConstants.tronscanapi,
      '/api/chainparameters',
      (json) => json,
    );
    return object;
  }

  // static Future<Object> getAccountResources() async {
  //   final WalletModel? wallet = await TronService().getWallet();
  //   if (wallet == null) return '{}';
  //   Object object = await NetworkClients.get(
  //       'api.trongrid.io', '/wallet/getaccountresource', (json) => json,
  //       parameters: {
  //         "address": wallet.address,
  //         // 'address': 'TJ8mAiRSaxB8ZvjKvWwRnsxmUnXKzgKfxk',
  //         "visible": 'true'
  //       },
  //       headers: {
  //         'Content-Type': 'application/json',
  //       });
  //   return object;
  // }

  // static Future<Object> getTips(String name) async {
  //   Object object = await NetworkClients.get(
  //       UrlConstants.tipsAPI, '/api/tips/$name', (json) => json,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       });
  //   return object;
// }
}
