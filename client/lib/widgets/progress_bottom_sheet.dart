import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProgressBottomSheet extends StatefulWidget {
  final String challengeId;
  final String challengeTitle;
  final double currentProgress;
  final double totalProgress;

  const ProgressBottomSheet({
    Key? key,
    required this.challengeId,
    required this.challengeTitle,
    required this.currentProgress,
    required this.totalProgress,
  }) : super(key: key);

  @override
  ProgressBottomSheetState createState() => ProgressBottomSheetState();
}

class ProgressBottomSheetState extends State<ProgressBottomSheet> {
  final TextEditingController _progressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _progressController.text = widget.currentProgress.toString();
  }

  Future<void> _submitProgress() async {
    final progressText = _progressController.text.trim();
    if (progressText.isEmpty) return;

    final progress = double.tryParse(progressText);
    if (progress == null || progress < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите корректное число')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/challenges/${widget.challengeId}/progress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'progress': progress}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Navigator.of(context).pop(data); 
        
        if (data['challenge']['completed'] == true) {
          _showCompletionDialog(data['challenge']);
        }
      } else {
        throw Exception('Ошибка сервера');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showCompletionDialog(Map<String, dynamic> challenge) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Поздравляем!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Вы успешно завершили челлендж:'),
            const SizedBox(height: 8),
            Text(
              challenge['title'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('🏆 Молодец! Так держать!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отлично!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Отметить прогресс',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.challengeTitle,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _progressController,
              decoration: InputDecoration(
                labelText: 'Сколько выполнил?',
                hintText: 'Например: 0.5',
                border: const OutlineInputBorder(),
                suffixText: '/ ${widget.totalProgress}',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitProgress,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Сохранить прогресс'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}