import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../models/api_request.dart';
import '../providers/theme_provider.dart';
import '../widgets/request_form.dart';
import '../widgets/request_history.dart';
import '../widgets/response_viewer.dart';
import 'login_screen.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  late TabController _tabController;
  bool _isLoading = false;
  ApiRequestResult? _lastResult;
  ApiRequest? _currentRequest;

  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  String _selectedMethod = 'GET';
  final Map<String, String> _headers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initStorage();
  }

  Future<void> _initStorage() async {
    await _storageService.init();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _urlController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _makeRequest() async {
    if (_urlController.text.isEmpty) {
      _showSnackBar('Please enter a URL', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _lastResult = null;
    });

    final requestId = const Uuid().v4();
    final timestamp = DateTime.now();

    try {
      final result = await _apiService.makeRequest(
        method: _selectedMethod,
        url: _urlController.text.trim(),
        headers: _headers.isNotEmpty ? _headers : null,
        body: _bodyController.text.isNotEmpty ? _bodyController.text : null,
      );

      setState(() {
        _lastResult = result;
      });

      // Save request to storage
      final apiRequest = ApiRequest(
        id: requestId,
        method: _selectedMethod,
        url: _urlController.text.trim(),
        headers: _headers,
        body: _bodyController.text.isNotEmpty ? _bodyController.text : null,
        timestamp: timestamp,
        statusCode: result.statusCode,
        response: result.response,
      );

      _currentRequest = apiRequest;
      await _storageService.saveRequest(apiRequest);

      _showSnackBar(
        'Request completed: ${result.statusCode} ${result.statusMessage}',
        isError: !result.isSuccess,
      );
    } catch (e) {
      // Save failed request
      final apiRequest = ApiRequest(
        id: requestId,
        method: _selectedMethod,
        url: _urlController.text.trim(),
        headers: _headers,
        body: _bodyController.text.isNotEmpty ? _bodyController.text : null,
        timestamp: timestamp,
        error: e.toString(),
      );

      await _storageService.saveRequest(apiRequest);

      _showSnackBar('Error: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleSignOut() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      _showSnackBar('Error signing out: ${e.toString()}', isError: true);
    }
  }

  void _loadRequestFromHistory(ApiRequest request) {
    setState(() {
      _selectedMethod = request.method;
      _urlController.text = request.url;
      _bodyController.text = request.body ?? '';
      _headers.clear();
      _headers.addAll(request.headers);
      _currentRequest = request;

      if (request.statusCode != null && request.response != null) {
        _lastResult = ApiRequestResult(
          statusCode: request.statusCode!,
          response: request.response!,
          headers: {},
          duration: Duration.zero,
        );
      }
    });

    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Client'),
        elevation: 0,
        actions: [
          // Theme Toggle
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle theme',
          ),

          // User Profile
          PopupMenuButton<void>(
            icon: CircleAvatar(
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? Text(user?.displayName?[0] ?? 'U')
                  : null,
            ),
            itemBuilder: (context) => <PopupMenuEntry<void>>[
              PopupMenuItem<void>(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? 'User',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<void>(
                onTap: _handleSignOut,
                child: const Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Sign Out'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.send), text: 'Request'),
            Tab(icon: Icon(Icons.history), text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Request Tab
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RequestForm(
                    urlController: _urlController,
                    bodyController: _bodyController,
                    selectedMethod: _selectedMethod,
                    headers: _headers,
                    onMethodChanged: (method) {
                      setState(() => _selectedMethod = method);
                    },
                    onSendRequest: _makeRequest,
                    isLoading: _isLoading,
                  ),
                  if (_lastResult != null) ...[
                    const SizedBox(height: 24),
                    ResponseViewer(result: _lastResult!),
                  ],
                ],
              ),
            ),
          ),

          // History Tab
          RequestHistory(
            storageService: _storageService,
            onRequestSelected: _loadRequestFromHistory,
          ),
        ],
      ),
    );
  }
}
