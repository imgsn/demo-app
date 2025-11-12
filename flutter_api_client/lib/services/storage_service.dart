import 'package:hive_flutter/hive_flutter.dart';
import '../models/api_request.dart';

class StorageService {
  static const String _requestsBoxName = 'api_requests';
  late Box<ApiRequest> _requestsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ApiRequestAdapter());
    _requestsBox = await Hive.openBox<ApiRequest>(_requestsBoxName);
  }

  Future<void> saveRequest(ApiRequest request) async {
    await _requestsBox.put(request.id, request);
  }

  List<ApiRequest> getAllRequests() {
    return _requestsBox.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  ApiRequest? getRequest(String id) {
    return _requestsBox.get(id);
  }

  Future<void> deleteRequest(String id) async {
    await _requestsBox.delete(id);
  }

  Future<void> clearAllRequests() async {
    await _requestsBox.clear();
  }

  Stream<List<ApiRequest>> watchRequests() {
    return _requestsBox.watch().map((event) {
      return _requestsBox.values.toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  int get requestCount => _requestsBox.length;
}
