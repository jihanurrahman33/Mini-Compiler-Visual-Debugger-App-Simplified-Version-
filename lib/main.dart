// Mini Compiler + Visual Debugger App (Simplified Version)

import 'package:flutter/material.dart';

void main() {
  runApp(const CompilerApp());
}

class CompilerApp extends StatelessWidget {
  const CompilerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Compiler',
      theme: ThemeData.dark(),
      home: const CompilerHomePage(),
    );
  }
}

class CompilerHomePage extends StatefulWidget {
  const CompilerHomePage({super.key});

  @override
  State<CompilerHomePage> createState() => _CompilerHomePageState();
}

class _CompilerHomePageState extends State<CompilerHomePage> {
  final TextEditingController _controller = TextEditingController();
  List<String> tokens = [];
  List<String> intermediateCode = [];
  String errorMessage = '';

  void _analyzeCode() {
    String code = _controller.text;
    setState(() {
      tokens = _tokenize(code);
      errorMessage = _checkSyntax(tokens);
      intermediateCode =
          errorMessage.isEmpty ? _generateIntermediateCode(tokens) : [];
    });
  }

  List<String> _tokenize(String code) {
    final regex = RegExp(r'[a-zA-Z_][a-zA-Z0-9_]*|\d+|[=+\-*/;()]');
    return regex.allMatches(code).map((match) => match.group(0)!).toList();
  }

  String _checkSyntax(List<String> tokens) {
    if (tokens.isEmpty) return 'No code entered.';
    if (!tokens.contains('=')) return 'Missing assignment operator (=).';
    if (!tokens.contains(';')) return 'Missing semicolon (;) at the end.';
    return '';
  }

  List<String> _generateIntermediateCode(List<String> tokens) {
    List<String> code = [];
    // Example: a = b + 5;
    if (tokens.length >= 5 &&
        tokens[1] == '=' &&
        tokens[tokens.length - 1] == ';') {
      String target = tokens[0];
      String operand1 = tokens[2];
      String operator = tokens[3];
      String operand2 = tokens[4];
      code.add('t1 = $operand1 $operator $operand2');
      code.add('$target = t1');
    } else {
      code.add('Unsupported expression.');
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini Compiler')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter Code:'),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _analyzeCode,
              child: const Text('Analyze'),
            ),
            const SizedBox(height: 20),
            if (errorMessage.isNotEmpty) ...[
              const Text('Errors:', style: TextStyle(color: Colors.red)),
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            ] else ...[
              const Text('Tokens:'),
              Wrap(children: tokens.map((t) => Chip(label: Text(t))).toList()),
              const SizedBox(height: 10),
              const Text('Intermediate Code:'),
              for (var line in intermediateCode) Text(line),
            ],
          ],
        ),
      ),
    );
  }
}
