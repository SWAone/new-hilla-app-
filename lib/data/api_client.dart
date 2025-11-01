import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../shared/env.dart';

class ApiClient {
  ApiClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    final base = Env.baseUrl.endsWith('/') ? Env.baseUrl.substring(0, Env.baseUrl.length - 1) : Env.baseUrl;
    final full = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$base$full');
    if (query == null || query.isEmpty) return uri;
    return uri.replace(queryParameters: query.map((k, v) => MapEntry(k, '$v')));
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) async {
    final uri = _buildUri(path, query);
    final response = await _http.get(
      uri,
      headers: <String, String>{
        'Accept': 'application/json',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'HTTP ${response.statusCode}',
        body: response.body,
      );
    }

    try {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) return decoded;
      throw const FormatException('Unexpected JSON format');
    } catch (e, s) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('JSON decode error: $e\n$s');
      }
      rethrow;
    }
  }

  void dispose() {
    _http.close();
  }
}

class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.message, this.body});
  final int statusCode;
  final String message;
  final String? body;

  @override
  String toString() => 'ApiException($statusCode): $message';
}


