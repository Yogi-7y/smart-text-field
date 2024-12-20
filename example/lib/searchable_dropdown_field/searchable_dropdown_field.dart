import 'package:flutter/material.dart';
import 'package:smart_textfield/smart_textfield.dart';

import 'async_search_example.dart';
import 'sync_search_example.dart';

const _backgroundColor = Color(0xFFF1F5F9);
const textPrimaryColor = Color(0xFF334155);
const textSecondaryColor = Color(0xFF64748B);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const SmartTextFieldOverlay(
      child: MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _searchableDropdownFieldData = SearchableDropdownFieldData(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'TextFormField',
                  border: OutlineInputBorder(),
                ),
              ),
              const AsyncSearchExample(),
              SyncSearchExample(data: _searchableDropdownFieldData),
              const DropdownFormFieldExample(),
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownFormFieldExample extends StatefulWidget {
  const DropdownFormFieldExample({super.key});

  @override
  State<DropdownFormFieldExample> createState() => _DropdownFormFieldExampleState();
}

class _DropdownFormFieldExampleState extends State<DropdownFormFieldExample> {
  List<String> optionsList = ['Option 1', 'Option 2', 'Option 3'];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: const InputDecoration(
        labelText: 'Choose an option',
        border: OutlineInputBorder(),
      ),
      onChanged: (newValue) {
        setState(() {
          selectedValue = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an option';
        }
        return null;
      },
      items: optionsList.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
