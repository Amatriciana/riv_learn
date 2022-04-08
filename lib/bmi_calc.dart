import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final text1StateProvider =
    StateProvider.autoDispose((ref) => TextEditingController());
final text2StateProvider =
    StateProvider.autoDispose((ref) => TextEditingController());
final resultStateNotifierProvider =
    StateNotifierProvider((ref) => ResultStateNotifier());

class ResultStateNotifier extends StateNotifier {
  ResultStateNotifier() : super(0);

  void calclate(text1, text2) {
    int a = int.parse(text1.state.text);
    int b = int.parse(text2.state.text);
    state = a + b;
  }
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text1 = ref.watch(text1StateProvider.notifier);
    final text2 = ref.watch(text2StateProvider.notifier);
    final result = ref.watch(resultStateNotifierProvider.notifier);
    final result2 = ref.watch(resultStateNotifierProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BMI Calculator'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Result: $result2'),
              TextField(
                controller: text1.state,
              ),
              TextField(
                controller: text2.state,
              ),
              ElevatedButton(
                child: const Text('計算'),
                onPressed: () {
                  result.calclate(text1, text2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
