import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final countProvider = StateNotifierProvider((ref) => CountNotifier());

class CountNotifier extends StateNotifier {
  CountNotifier() : super(0);
  void increment() => state++;
  void decrement() => state--;
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countState = ref.watch(countProvider.notifier);
    final count = ref.watch(countProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Riverpod'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Count: $count'),
              FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  countState.increment();
                },
              ),
              FloatingActionButton(
                child: const Icon(Icons.remove),
                onPressed: () {
                  countState.decrement();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
