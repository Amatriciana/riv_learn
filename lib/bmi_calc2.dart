import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final resultStateNotifierProvider =
    StateNotifierProvider((ref) => ResultStateNotifier());

class ResultStateNotifier extends StateNotifier {
  ResultStateNotifier() : super(0);

  void calclate(String height, String weight) {
    double a = double.parse(height);
    double b = double.parse(weight);
    state = b / (a * a / 10000);
  }

  Future<void> getResult() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble('result') ?? 0;
  }

  Future<void> setForm(String height, String weight) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('height', height);
    prefs.setString('weight', weight);
    prefs.setDouble('result', state);
  }
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heightTextEditingController = useTextEditingController();
    final weightTextEditingController = useTextEditingController();

    final calculate = ref.watch(resultStateNotifierProvider.notifier);
    final result = ref.watch(resultStateNotifierProvider);

    // 初期値代入
    useEffect(() {
      Future(() async {
        final prefs = await SharedPreferences.getInstance();
        heightTextEditingController.text = prefs.getString('height') ?? '';
        weightTextEditingController.text = prefs.getString('weight') ?? '';
        calculate.getResult();
      });
      return null;
    }, []);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BMI Calculator'),
        ),
        body: Container(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: heightTextEditingController,
                decoration: const InputDecoration(
                  labelText: '身長',
                  hintText: '身長を入力',
                ),
              ),
              TextField(
                controller: weightTextEditingController,
                decoration: const InputDecoration(
                  labelText: '体重',
                  hintText: '体重を入力',
                ),
              ),
              ElevatedButton(
                child: const Text('計算'),
                onPressed: () {
                  calculate.calclate(
                    heightTextEditingController.text,
                    weightTextEditingController.text,
                  );
                  calculate.setForm(
                    heightTextEditingController.text,
                    weightTextEditingController.text,
                  );
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
