// Search Provider
import 'package:flutter/material.dart';
import 'package:smart_textfield/smart_textfield.dart';

import 'async_search_example.dart';
import 'sync_search_example.dart';

void main() {
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
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AsyncSearchExample(),
              SyncSearchExample(),
            ],
          ),
        ),
      ),
    );
  }
}
