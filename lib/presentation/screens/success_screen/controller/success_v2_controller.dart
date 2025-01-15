import 'package:tron_stake/domain/mixin/log_mixin.dart';
import 'package:flutter/cupertino.dart';

enum StatusPay { loading, confirm, error }

class SuccessV2Controller extends ChangeNotifier with LoggingMixin {
  SuccessV2Controller(this._sessionId) {
    logCreation();
    initState();
  }
  void initState() => init();
  StatusPay _statusPay = StatusPay.loading;
  final String? _sessionId;
  bool _loading = true;

  StatusPay get statusPay => _statusPay;
  bool get loading => _loading;
  String? get sessionId => _sessionId;

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

  check() {
    if (_sessionId == null) setStatusPay = StatusPay.error;
    setStatusPay = StatusPay.confirm;
    // if (isWeb) {
    //   Timer.periodic(const Duration(seconds: 3), (t) async {
    //     final user = userController.user;
    //     if (user == null) return;
    //     final String? sessionId =
    //         user.data.bettingUser.data.attributes.sessionId;
    //     if (sessionId == null) return;
    //     final Object object = await Apis.retrieveSubscription(sessionId);
    //     if (object is Success) {
    //       final status = json.decode(object.response.toString())['status'];
    //       if (status == 'active') {
    //         setPremium = true;
    //         t.cancel();
    //       }
    //     }
    //     if (object is Failure) {
    //       final response = object.errorResponse;
    //       log('responseFailure: $response');
    //     }
    //   });
    //   return;
    // }
  }

  Future<void> init() async {
    setLoading = true;
    check();
    setLoading = false;
  }
}
