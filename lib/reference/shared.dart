import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final calculateProvider = StateNotifierProvider((ref) => CalculateState());

class CalculateState extends StateNotifier {
  CalculateState() : super(0);

  void calculate(String form1, String form2) {
    state = int.parse(form1) + int.parse(form2);
  }

  Future<void> getResultPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('result');
  }

  Future<void> setResultPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('result', state);
  }

  Future<void> setFormPrefs(form1, form2) async {
    final List<String> formlist = [
      form1,
      form2,
    ];
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('formList', formlist);
  }

  Future<void> getFormPrefs(form1, form2) async {
    final prefs = await SharedPreferences.getInstance();
    final formList = prefs.getStringList('formList');

    form1.text = formList?[0];
    form2.text = formList?[1];
  }
}

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form1Controller = useTextEditingController();
    final form2Controller = useTextEditingController();
    final result = ref.watch(calculateProvider);
    final calculate = ref.watch(calculateProvider.notifier);

    useEffect(() {
      Future(() async {
        calculate.getResultPrefs();

        calculate.getFormPrefs(
          form1Controller,
          form2Controller,
        );
      });
      return null;
    }, []);

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('Title')),
          body: Container(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Result: $result'),
                TextField(controller: form1Controller),
                TextField(
                  controller: form2Controller,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Button'),
                  onPressed: () {
                    calculate.calculate(
                        form1Controller.text, form2Controller.text);
                    calculate.setResultPrefs();
                    calculate.setFormPrefs(
                        form1Controller.text, form2Controller.text);
                  },
                ),
              ],
            ),
          )),
    );
  }
}
