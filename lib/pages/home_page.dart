// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();

  List<Map> _voices = [];
  Map? _currentVoice;
  bool _isEnglish = true;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  void initTTS() {
    _flutterTts.setProgressHandler((text, start, end, word) {
      setState(() {});
    });
    _flutterTts.getVoices.then((data) {
      try {
        List<Map> voices = List<Map>.from(data);
        setState(() {
          _voices = voices
              .where((voice) =>
                  voice["name"].contains("en") || voice["name"].contains("ar"))
              .toList();
          _currentVoice = _voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  void _speakText() {
    if (_textController.text.isNotEmpty) {
      _flutterTts.speak(_textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6200EE),
        title: Text(
          _isEnglish ? "Text-to-Speech" : "النص إلى كلام",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: () {
              setState(() {
                _isEnglish = !_isEnglish;
                _currentVoice = _voices.firstWhere((voice) => _isEnglish
                    ? voice["locale"].startsWith("en")
                    : voice["locale"].startsWith("ar"));
                setVoice(_currentVoice!);
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEnglish ? "Enter text to speak" : "أدخل النص للتحدث",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _textController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText:
                        _isEnglish ? "Type something..." : "اكتب شيئًا...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0, 
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _speakText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6200EE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _isEnglish ? "Speak" : "تحدث",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                _speakerSelector(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _speakerSelector() {
    return DropdownButton<Map>(
      dropdownColor: Colors.blue[200],
      iconEnabledColor: Colors.blue[200],
      value: _currentVoice,
      isExpanded: true,
      items: _voices
          .map(
            (voice) => DropdownMenuItem(
              value: voice,
              child: Text(
                voice["name"],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _currentVoice = value;
          setVoice(_currentVoice!);
        });
      },
    );
  }
}
