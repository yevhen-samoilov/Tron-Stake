import 'package:flutter/cupertino.dart';

enum StatusPay { loading, confirm, error }

class SuccessController extends ChangeNotifier {
  SuccessController(this._uuId, this._payId) {
    initState();
  }
  void initState() => init();
  StatusPay _statusPay = StatusPay.loading;
  final String? _uuId;
  final String? _payId;
  bool _loading = true;

  StatusPay get statusPay => _statusPay;
  bool get loading => _loading;
  String? get uuId => _uuId;
  String? get payId => _payId;

  set setStatusPay(StatusPay s) {
    if (_statusPay == s) return;
    _statusPay = s;
    notifyListeners();
  }

  set setLoading(bool l) {
    if (_loading == l) {
      return;
    }
    _loading = l;
    notifyListeners();
  }

  Future<void> init() async {
    setLoading = true;
    setLoading = false;
  }
}
