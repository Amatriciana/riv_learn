import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final counterProvider = StateNotifierProvider((ref) => CounterStateNotifier());

class CounterStateNotifier extends StateNotifier {
  CounterStateNotifier() : super(0);
  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }

  void reset() {
    state = 0;
  }
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final countState = ref.watch(counterProvider.notifier);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CounterApp'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Count: $count'),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      countState.increment();
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FloatingActionButton(
                    child: const Icon(Icons.remove),
                    onPressed: () {
                      countState.decrement();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('リセット'),
                onPressed: () {
                  countState.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
