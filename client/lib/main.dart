import 'package:client/client.dart';
import 'package:client/presentation/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const BDUIApp());
}

class BDUIApp extends StatelessWidget {
  const BDUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Challenges - BDUI',
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BDUIHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BDUIHomeScreen extends StatefulWidget {
  const BDUIHomeScreen({super.key});

  @override
  BDUIHomeScreenState createState() => BDUIHomeScreenState();
}

class BDUIHomeScreenState extends State<BDUIHomeScreen> {
  Map<String, dynamic>? _bduiData;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadBDUIFromServer();
  }

  Future<void> _loadBDUIFromServer() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final response = await http.get(
        Uri.parse('http://localhost:8080/api/bdui/challenges'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _bduiData = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = 'Не удалось загрузить данные: $e';
        _isLoading = false;
      });
    }
  }

  void _refreshData() {
    _loadBDUIFromServer();
  }

  @override
  Widget build(BuildContext context) {
    print('BDUI Data: $_bduiData');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Challenges - BDUI'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshData,
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                )
              : _buildBDUIContent(),
    );
  }

  Widget _buildBDUIContent() {
    if (_bduiData == null) {
      return const Center(child: Text('Нет данных'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: BDUIEngine.renderFromJson(
        json: _bduiData!, 
        context: context,
        onDataUpdated: _refreshData,
      ),
    );
  }
}