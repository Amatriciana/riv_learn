import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final counterProvider = StateNotifierProvider((ref) => CounterStateNotifier());

class CounterStateNotifier extends StateNotifier {
  CounterStateNotifier() : super(0);

  void increment() => state++; //カウント加算
  void decrement() => state--; //カウント減算
  void reset() => state = 0; //カウントリセット

  // SharedPreferencesに保存されたデータを反映
  Future<void> getCountPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('counter') ?? 0;
  }

  // SharedPreferencesにカウント数を保存
  Future<void> setCountPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', state);
  }
}

class CounterApp extends HookConsumerWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final countState = ref.watch(counterProvider.notifier);

    useEffect(() {
      Future(() {
        countState.getCountPrefs();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CounterApp'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Count: $count'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    countState.increment();
                    countState.setCountPrefs();
                  },
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  child: const Icon(Icons.remove),
                  onPressed: () {
                    countState.decrement();
                    countState.setCountPrefs();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('リセット'),
              onPressed: () {
                countState.reset();
                countState.setCountPrefs();
              },
            ),
          ],
        ),
      ),
    );
  }
}
