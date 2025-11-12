import 'package:hive/hive.dart';

part 'api_request.g.dart';

@HiveType(typeId: 0)
class ApiRequest extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String method;

  @HiveField(2)
  String url;

  @HiveField(3)
  Map<String, String> headers;

  @HiveField(4)
  String? body;

  @HiveField(5)
  DateTime timestamp;

  @HiveField(6)
  int? statusCode;

  @HiveField(7)
  String? response;

  @HiveField(8)
  String? error;

  ApiRequest({
    required this.id,
    required this.method,
    required this.url,
    required this.headers,
    this.body,
    required this.timestamp,
    this.statusCode,
    this.response,
    this.error,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'method': method,
        'url': url,
        'headers': headers,
        'body': body,
        'timestamp': timestamp.toIso8601String(),
        'statusCode': statusCode,
        'response': response,
        'error': error,
      };

  factory ApiRequest.fromJson(Map<String, dynamic> json) => ApiRequest(
        id: json['id'] as String,
        method: json['method'] as String,
        url: json['url'] as String,
        headers: Map<String, String>.from(json['headers'] as Map),
        body: json['body'] as String?,
        timestamp: DateTime.parse(json['timestamp'] as String),
        statusCode: json['statusCode'] as int?,
        response: json['response'] as String?,
        error: json['error'] as String?,
      );
}
