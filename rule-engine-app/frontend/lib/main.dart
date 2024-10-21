import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rule Engine App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RuleEnginePage(),
    );
  }
}

class RuleEnginePage extends StatefulWidget {
  @override
  _RuleEnginePageState createState() => _RuleEnginePageState();
}

class _RuleEnginePageState extends State<RuleEnginePage> {
  final _formKey = GlobalKey<FormState>();
  String _ruleName = '';
  String _ruleString = '';
  String _result = '';
  List<dynamic> _rules = [];
  int? _selectedRuleId;
  Map<String, dynamic> _userData = {
    'age': 0,
    'department': '',
    'salary': 0,
    'experience': 0
  };

  @override
  void initState() {
    super.initState();
    _fetchRules();
  }

  Future<void> _createRule() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/rules/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _ruleName,
        'ast': {'type': 'operand', 'value': _ruleString}
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _result = 'Rule created successfully';
      });
      _fetchRules();
    } else {
      setState(() {
        _result = 'Failed to create rule';
      });
    }
  }

  Future<void> _fetchRules() async {
    final response = await http.get(Uri.parse('http://localhost:8000/rules'));
    if (response.statusCode == 200) {
      setState(() {
        _rules = json.decode(response.body);
        if (_rules.isNotEmpty && _selectedRuleId == null) {
          _selectedRuleId = _rules[0]['id'];
        }
      });
    }
  }

  Future<void> _evaluateRule() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/rules/evaluate?rule_id=$_selectedRuleId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(_userData),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        _result = 'Rule evaluation result: ${result['result']}';
      });
    } else {
      setState(() {
        _result = 'Failed to evaluate rule';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rule Engine'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Rule Name'),
              onChanged: (value) => _ruleName = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Rule String'),
              onChanged: (value) => _ruleString = value,
            ),
            ElevatedButton(
              onPressed: _createRule,
              child: Text('Create Rule'),
            ),
            SizedBox(height: 20),
            DropdownButton<int>(
              value: _selectedRuleId,
              onChanged: (int? newValue) {
                setState(() {
                  _selectedRuleId = newValue;
                });
              },
              items: _rules.map<DropdownMenuItem<int>>((dynamic rule) {
                return DropdownMenuItem<int>(
                  value: rule['id'],
                  child: Text(rule['name']),
                );
              }).toList(),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Salary'),
              keyboardType: TextInputType.number,
              onChanged: (value) => _userData['salary'] = int.tryParse(value) ?? 0,
            ),
            ElevatedButton(
              onPressed: _evaluateRule,
              child: Text('Evaluate Rule'),
            ),
            SizedBox(height: 20),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
