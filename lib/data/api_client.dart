import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'env.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient({String? baseUrl})
    : _baseUrl = (baseUrl ?? apiBaseUrl).replaceAll(RegExp(r'/$'), '');

  final String _baseUrl;
  final _headers = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
  };
  final _timeout = const Duration(seconds: 15);

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse(
      '$_baseUrl$cleanPath',
    ).replace(queryParameters: _cleanQuery(query));
  }

  Map<String, String>? _cleanQuery(Map<String, dynamic>? query) {
    if (query == null) return null;
    final out = <String, String>{};
    query.forEach((k, v) {
      if (v == null) return;
      out[k] = v.toString();
    });
    return out;
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final res = await http
        .get(_uri(path, query), headers: _headers)
        .timeout(_timeout);
    return _handle(res);
  }

  Future<dynamic> post(String path, {Object? body}) async {
    final res = await http
        .post(_uri(path), headers: _headers, body: jsonEncode(body ?? {}))
        .timeout(_timeout);
    return _handle(res);
  }

  Future<dynamic> patch(String path, {Object? body}) async {
    final res = await http
        .patch(_uri(path), headers: _headers, body: jsonEncode(body ?? {}))
        .timeout(_timeout);
    return _handle(res);
  }

  Future<dynamic> put(String path, {Object? body}) async {
    final res = await http
        .put(_uri(path), headers: _headers, body: jsonEncode(body ?? {}))
        .timeout(_timeout);
    return _handle(res);
  }

  Future<void> delete(String path) async {
    final res = await http
        .delete(_uri(path), headers: _headers)
        .timeout(_timeout);
    _handle(res);
  }

  dynamic _handle(http.Response res) {
    final status = res.statusCode;
    dynamic data;
    try {
      data = res.body.isEmpty ? null : jsonDecode(res.body);
    } catch (_) {
      data = res.body;
    }

    if (status >= 200 && status < 300) {
      return data;
    }
    final msg = (data is Map && data['message'] != null)
        ? data['message'].toString()
        : (data is String ? data : 'Erro HTTP $status');
    throw ApiException(msg, statusCode: status);
  }
}
