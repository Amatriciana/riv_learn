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
    double a = double.parse(text1.state.text) / 100;
    double b = double.parse(text2.state.text);
    state = b / (a * a);
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
    final calculate = ref.watch(resultStateNotifierProvider.notifier);
    final result = ref.watch(resultStateNotifierProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BMI Calculator'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: text1.state,
                decoration: const InputDecoration(
                  labelText: '身長',
                  hintText: '身長を入力',
                ),
              ),
              TextField(
                controller: text2.state,
                decoration: const InputDecoration(
                  labelText: '体重',
                  hintText: '体重を入力',
                ),
              ),
              ElevatedButton(
                child: const Text('計算'),
                onPressed: () {
                  calculate.calclate(text1, text2);
                },
              ),
              Text('Result: $result'),
            ],
          ),
        ),
      ),
    );
  }
}
