import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// final text1StateProvider =
//     StateProvider.autoDispose((ref) => TextEditingController());
// final text2StateProvider =
//     StateProvider.autoDispose((ref) => TextEditingController());
final resultStateNotifierProvider =
    StateNotifierProvider((ref) => ResultStateNotifier());

class ResultStateNotifier extends StateNotifier {
  ResultStateNotifier() : super(0);

  void calclate(height, weight) {
    double a = double.parse(height) / 100;
    double b = double.parse(weight);
    state = b / (a * a);
  }

  Future<void> getResult() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble('result') ?? 0;
  }

  Future<void> setResult() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('result', state);
  }

  Future<double> getHeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('height') ?? 0;
  }

  Future<void> setHeight(double height) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('height', height);
  }

  Future<double> getWeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('weight') ?? 0;
  }

  Future<void> setWeight(double weight) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('weight', weight);
  }
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = useState<double>(0);
    final heightTextEditingController = useTextEditingController();

    final weight = useState<double>(0);
    final weightTextEditingController = useTextEditingController();

    final calculate = ref.watch(resultStateNotifierProvider.notifier);
    final result = ref.watch(resultStateNotifierProvider);

    // 初期値代入
    useEffect(() {
      Future(() async {
        height.value = await calculate.getHeight();
        heightTextEditingController.text = height.value.toString();

        weight.value = await calculate.getWeight();
        weightTextEditingController.text = weight.value.toString();

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
                  calculate.calclate(heightTextEditingController.text,
                      weightTextEditingController.value.text);
                  calculate.setResult();
                  calculate.setHeight(
                      double.parse(heightTextEditingController.text));
                  calculate.setWeight(
                      double.parse(weightTextEditingController.text));
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
