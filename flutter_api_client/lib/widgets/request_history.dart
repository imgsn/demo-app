import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/api_request.dart';
import '../services/storage_service.dart';

class RequestHistory extends StatefulWidget {
  final StorageService storageService;
  final Function(ApiRequest) onRequestSelected;

  const RequestHistory({
    super.key,
    required this.storageService,
    required this.onRequestSelected,
  });

  @override
  State<RequestHistory> createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistory> {
  List<ApiRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    setState(() {
      _requests = widget.storageService.getAllRequests();
    });
  }

  Future<void> _deleteRequest(String id) async {
    await widget.storageService.deleteRequest(id);
    _loadRequests();
  }

  Future<void> _clearAllRequests() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text(
          'Are you sure you want to delete all request history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.storageService.clearAllRequests();
      _loadRequests();
    }
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'GET':
        return Colors.green;
      case 'POST':
        return Colors.blue;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      case 'PATCH':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(ApiRequest request) {
    if (request.error != null) {
      return 'Error';
    }
    if (request.statusCode != null) {
      final code = request.statusCode!;
      if (code >= 200 && code < 300) return 'Success';
      if (code >= 300 && code < 400) return 'Redirect';
      if (code >= 400 && code < 500) return 'Client Error';
      if (code >= 500) return 'Server Error';
    }
    return 'Unknown';
  }

  Color _getStatusColor(ApiRequest request) {
    if (request.error != null) return Colors.red;
    if (request.statusCode != null) {
      final code = request.statusCode!;
      if (code >= 200 && code < 300) return Colors.green;
      if (code >= 300 && code < 400) return Colors.blue;
      if (code >= 400 && code < 500) return Colors.orange;
      if (code >= 500) return Colors.red;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No request history',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your API requests will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header with Clear All button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_requests.length} Request${_requests.length != 1 ? 's' : ''}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.delete_sweep, size: 20),
                label: const Text('Clear All'),
                onPressed: _clearAllRequests,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),

        // Request List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _requests.length,
            itemBuilder: (context, index) {
              final request = _requests[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => widget.onRequestSelected(request),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Method Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getMethodColor(request.method)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                request.method,
                                style: TextStyle(
                                  color: _getMethodColor(request.method),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(request)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                request.statusCode?.toString() ??
                                    _getStatusLabel(request),
                                style: TextStyle(
                                  color: _getStatusColor(request),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),

                            // Delete Button
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              onPressed: () => _deleteRequest(request.id),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // URL
                        Text(
                          request.url,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Timestamp
                        Text(
                          DateFormat('MMM dd, yyyy - HH:mm:ss')
                              .format(request.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),

                        // Error message if present
                        if (request.error != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    request.error!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
