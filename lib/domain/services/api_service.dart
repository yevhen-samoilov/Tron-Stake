import 'dart:convert';
import 'dart:developer';
import 'package:tron_stake/data/remote/services/apis/apis.dart';
import 'package:tron_stake/data/remote/services/apis/apis_status.dart';

class ApiService {
  static Future<String> getToken() async {
    try {
      Object getToken = await Apis.getToken();
      if (getToken is Failure) {
        log('getToken: ${getToken.errorResponse}');
        return '';
      }
      getToken as Success;
      final token = (json.decode(getToken.response.toString()))['token'];
      return token;
    } catch (e) {
      return '';
    }
  }
}
