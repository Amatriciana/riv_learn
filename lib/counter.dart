import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CounterApp'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Count: 数字'),
              const SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
