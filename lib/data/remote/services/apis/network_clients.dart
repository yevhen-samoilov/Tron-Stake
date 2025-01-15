import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tron_stake/constants/response_constants.dart';
import 'package:tron_stake/constants/url_constants.dart';
import 'package:tron_stake/data/remote/services/apis/apis_status.dart';

class NetworkClients {
  static Uri _makeUri(
      String host, String path, Map<String, dynamic>? parameters) {
    final uri = Uri.https(host);
    return uri.replace(path: path, queryParameters: parameters);
  }

  static Future<Object> get(
    String host,
    String path,
    Function(String json) parser, {
    Map<String, dynamic>? parameters,
    Map<String, String>? headers,
  }) async {
    final url = _makeUri(host, path, parameters);
    try {
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final String body = utf8.decode(response.bodyBytes);
      return Success(response: parser(body));
    }
    return Failure(code: 100, errorResponse: ResponseConstants.error100);
    } on HttpException {
      return Failure(code: 101, errorResponse: ResponseConstants.error101);
    } on FormatException {
      return Failure(code: 102, errorResponse: ResponseConstants.error102);
    } catch (e) {
      log('get $e');
      return Failure(code: 103, errorResponse: ResponseConstants.error103);
    }
  }

  static Future<Object> post(
    String host,
    String path,
    Function(String json) parser, {
    Map<String, dynamic>? parameters,
    Map<String, String>? headers,
    Object? body,
  }) async {
    final url = _makeUri(host, path, parameters);
    try {
      // log('url: $url');
      final response = await http.post(url, body: body, headers: headers);
      // log('response: ${response.body}');
      if (response.statusCode == 200) {
        final String body = utf8.decode(response.bodyBytes);
        return Success(response: parser(body));
      }
      log('post error100 ${response.body}');
      return Failure(code: 100, errorResponse: ResponseConstants.error100);
    } on HttpException {
      return Failure(code: 101, errorResponse: ResponseConstants.error101);
    } on FormatException {
      return Failure(code: 102, errorResponse: ResponseConstants.error102);
    } catch (e) {
      log('post $e');
      return Failure(
          code: 103, errorResponse: '${ResponseConstants.error103} || $e');
    }
  }

  static Future<Object> postData(
    String host,
    String path,
    Function(String json) parser,
    MultipartFile file, {
    Map<String, dynamic>? parameters,
    Map<String, String>? headers,
    Map<String, String>? body,
  }) async {
    final url = _makeUri(host, path, parameters);
    try {
    var request = http.MultipartRequest('POST', url)..files.add(file);

    if (headers != null) {
      request.headers.addAll(headers);
    }

    if (body != null) {
      request.fields.addAll(body);
    }

    var response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final u = utf8.encode(respStr);
      final String body = utf8.decode(u);

      return Success(response: parser(body));
    }
    // log('postData error100 ${response.body}');
    return Failure(code: 100, errorResponse: ResponseConstants.error100);
    } on HttpException {
      return Failure(code: 101, errorResponse: ResponseConstants.error101);
    } on FormatException {
      return Failure(code: 102, errorResponse: ResponseConstants.error102);
    } catch (e) {
      log('postData Error: $e');
      return Failure(
          code: 103, errorResponse: '${ResponseConstants.error103} || $e');
    }
  }

  static Future<http.Response> uploadImage(
      Uint8List imageBytes, String title, String description) async {
    var uri = Uri.parse('${UrlConstants.sbt}upload');
    log('message: $uri');
    var request = http.MultipartRequest('POST', uri);

    // Добавление изображения
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      imageBytes,
      filename: 'upload.png',
      contentType: MediaType('image', 'png'),
    ));

    // Добавление текстовых полей
    request.fields['title'] = title;
    request.fields['description'] = description;

    // Отправка запроса
    var response = await request.send();

    // Получение ответа от сервера
    if (response.statusCode == 200) {
      return response.stream
          .bytesToString()
          .then((value) => http.Response(value, 200));
    } else {
      throw Exception('Failed to upload image');
    }
  }

  static Future<Object> put(
    String host,
    String path,
    Function(String json) parser, {
    Map<String, dynamic>? parameters,
    Map<String, String>? headers,
    Object? body,
  }) async {
    final url = _makeUri(host, path, parameters);
    try {
      // log('url: $url');
      final response = await http.put(url, body: body, headers: headers);
      log('${response.statusCode} $url || response: ${response.body}');
      if (response.statusCode == 200) {
        final String body = utf8.decode(response.bodyBytes);
        return Success(response: parser(body));
      }
      log('put error100 ${response.body}');
      return Failure(code: 100, errorResponse: ResponseConstants.error100);
    } on HttpException {
      return Failure(code: 101, errorResponse: ResponseConstants.error101);
    } on FormatException {
      return Failure(code: 102, errorResponse: ResponseConstants.error102);
    } catch (e) {
      log('put $e');
      return Failure(
          code: 103, errorResponse: '${ResponseConstants.error103} || $e');
    }
  }
}
