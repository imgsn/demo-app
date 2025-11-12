import 'package:flutter/material.dart';

class RequestForm extends StatefulWidget {
  final TextEditingController urlController;
  final TextEditingController bodyController;
  final String selectedMethod;
  final Map<String, String> headers;
  final Function(String) onMethodChanged;
  final VoidCallback onSendRequest;
  final bool isLoading;

  const RequestForm({
    super.key,
    required this.urlController,
    required this.bodyController,
    required this.selectedMethod,
    required this.headers,
    required this.onMethodChanged,
    required this.onSendRequest,
    required this.isLoading,
  });

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  bool _showHeaders = false;
  bool _showBody = false;
  final List<String> _methods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];

  void _showHeaderDialog() {
    final keyController = TextEditingController();
    final valueController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Header'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: 'Key',
                hintText: 'Content-Type',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                hintText: 'application/json',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (keyController.text.isNotEmpty &&
                  valueController.text.isNotEmpty) {
                setState(() {
                  widget.headers[keyController.text] = valueController.text;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Method and URL Row
            Row(
              children: [
                // Method Selector
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: widget.selectedMethod,
                    underline: const SizedBox(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    borderRadius: BorderRadius.circular(8),
                    items: _methods.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(
                          method,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getMethodColor(method),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        widget.onMethodChanged(value);
                        setState(() {
                          _showBody = value != 'GET' && value != 'DELETE';
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // URL Input
                Expanded(
                  child: TextField(
                    controller: widget.urlController,
                    decoration: InputDecoration(
                      hintText: 'https://api.example.com/endpoint',
                      prefixIcon: const Icon(Icons.link),
                      suffixIcon: widget.urlController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                widget.urlController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Headers Section
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(_showHeaders
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                    label: Text('Headers (${widget.headers.length})'),
                    onPressed: () {
                      setState(() => _showHeaders = !_showHeaders);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                if (widget.selectedMethod != 'GET')
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(_showBody
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                      label: const Text('Body'),
                      onPressed: () {
                        setState(() => _showBody = !_showBody);
                      },
                    ),
                  ),
              ],
            ),

            // Headers List
            if (_showHeaders) ...[
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    ...widget.headers.entries.map((entry) {
                      return ListTile(
                        dense: true,
                        title: Text(entry.key),
                        subtitle: Text(entry.value),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () {
                            setState(() {
                              widget.headers.remove(entry.key);
                            });
                          },
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Header'),
                        onPressed: _showHeaderDialog,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Body Input
            if (_showBody && widget.selectedMethod != 'GET') ...[
              const SizedBox(height: 16),
              TextField(
                controller: widget.bodyController,
                decoration: const InputDecoration(
                  labelText: 'Request Body',
                  hintText: '{"key": "value"}',
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
              ),
            ],

            const SizedBox(height: 24),

            // Send Button
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: widget.isLoading ? null : widget.onSendRequest,
                icon: widget.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  widget.isLoading ? 'Sending...' : 'Send Request',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}
