import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BMI Calculator'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Result: 数字'),
              TextField(),
              TextField(),
              ElevatedButton(
                child: const Text('計算'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
