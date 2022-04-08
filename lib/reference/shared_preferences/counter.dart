import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final counterProvider = StateNotifierProvider((ref) => CounterStateNotifier());

class CounterStateNotifier extends StateNotifier {
  CounterStateNotifier() : super(0) {
    getPrefs();
  }
  void increment() => state++; //カウント加算
  void decrement() => state--; //カウント減算

  // SharedPreferencesに保存されたデータを反映
  Future<void> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('counter') ?? 0;
  }

  // SharedPreferencesにカウント数を保存
  Future<void> setPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', state);
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
        appBar: AppBar(title: const Text('CounterApp')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Count: $count'),
              FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  countState.increment();
                  countState.setPrefs();
                },
              ),
              FloatingActionButton(
                child: const Icon(Icons.remove),
                onPressed: () {
                  countState.decrement();
                  countState.setPrefs();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
