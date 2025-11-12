import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class ResponseViewer extends StatelessWidget {
  final ApiRequestResult result;

  const ResponseViewer({
    super.key,
    required this.result,
  });

  Color _getStatusColor() {
    if (result.statusCode >= 200 && result.statusCode < 300) {
      return Colors.green;
    } else if (result.statusCode >= 300 && result.statusCode < 400) {
      return Colors.blue;
    } else if (result.statusCode >= 400 && result.statusCode < 500) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Response',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  children: [
                    // Copy Response Button
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      tooltip: 'Copy response',
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: result.response),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Response copied to clipboard'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status Code and Duration
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: Icon(
                    result.isSuccess ? Icons.check_circle : Icons.error,
                    color: _getStatusColor(),
                    size: 20,
                  ),
                  label: Text(
                    '${result.statusCode} ${result.statusMessage}',
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: _getStatusColor().withOpacity(0.1),
                ),
                Chip(
                  avatar: const Icon(Icons.timer, size: 20),
                  label: Text('${result.duration.inMilliseconds}ms'),
                  backgroundColor: colorScheme.secondaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Response Headers
            if (result.headers.isNotEmpty) ...[
              ExpansionTile(
                title: const Text(
                  'Response Headers',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                initiallyExpanded: false,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: result.headers.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Response Body
            Text(
              'Response Body',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.2),
                ),
              ),
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  result.response.isEmpty ? '(Empty response)' : result.response,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: result.response.isEmpty
                        ? colorScheme.onSurface.withOpacity(0.5)
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
