import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_request.dart';

class ApiService {
  Future<ApiRequestResult> makeRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    String? body,
  }) async {
    try {
      // Validate URL
      final uri = Uri.parse(url);
      if (!uri.hasScheme || (!uri.isScheme('http') && !uri.isScheme('https'))) {
        throw Exception('Invalid URL. Must start with http:// or https://');
      }

      final Map<String, String> requestHeaders = headers ?? {};

      // Add default headers if not present
      if (!requestHeaders.containsKey('Content-Type') && body != null) {
        requestHeaders['Content-Type'] = 'application/json';
      }

      http.Response response;
      final startTime = DateTime.now();

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: requestHeaders)
              .timeout(const Duration(seconds: 30));
          break;

        case 'POST':
          response = await http.post(
            uri,
            headers: requestHeaders,
            body: body,
          ).timeout(const Duration(seconds: 30));
          break;

        case 'PUT':
          response = await http.put(
            uri,
            headers: requestHeaders,
            body: body,
          ).timeout(const Duration(seconds: 30));
          break;

        case 'DELETE':
          response = await http.delete(
            uri,
            headers: requestHeaders,
            body: body,
          ).timeout(const Duration(seconds: 30));
          break;

        case 'PATCH':
          response = await http.patch(
            uri,
            headers: requestHeaders,
            body: body,
          ).timeout(const Duration(seconds: 30));
          break;

        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      final duration = DateTime.now().difference(startTime);

      // Format response body
      String formattedResponse = response.body;
      try {
        final jsonData = jsonDecode(response.body);
        formattedResponse = const JsonEncoder.withIndent('  ').convert(jsonData);
      } catch (e) {
        // If not JSON, keep as is
      }

      return ApiRequestResult(
        statusCode: response.statusCode,
        response: formattedResponse,
        headers: response.headers,
        duration: duration,
      );
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout after 30 seconds');
      }
      rethrow;
    }
  }

  bool isValidJson(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  String formatJson(String jsonString) {
    try {
      final jsonData = jsonDecode(jsonString);
      return const JsonEncoder.withIndent('  ').convert(jsonData);
    } catch (e) {
      return jsonString;
    }
  }
}

class ApiRequestResult {
  final int statusCode;
  final String response;
  final Map<String, String> headers;
  final Duration duration;

  ApiRequestResult({
    required this.statusCode,
    required this.response,
    required this.headers,
    required this.duration,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  String get statusMessage {
    if (statusCode >= 200 && statusCode < 300) return 'Success';
    if (statusCode >= 300 && statusCode < 400) return 'Redirect';
    if (statusCode >= 400 && statusCode < 500) return 'Client Error';
    if (statusCode >= 500) return 'Server Error';
    return 'Unknown';
  }
}
