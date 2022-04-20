import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sqflite/sqflite.dart';

final formProvider =
    StateNotifierProvider<FormController, int>((ref) => FormController());

class FormController extends StateNotifier<int> {
  FormController() : super(0);

  void add(form1, form2, form3) {
    state = int.parse(form1) + int.parse(form2) + int.parse(form3);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait(
    [],
  );
  runApp(
    ProviderScope(
      overrides: [],
      child: Consumer(
        builder: (context, ref, child) {
          return child!;
        },
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form1Controller = useTextEditingController();
    final form2Controller = useTextEditingController();
    final form3Controller = useTextEditingController();

    final form = ref.watch(formProvider);
    final formState = ref.watch(formProvider.notifier);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('aaa'),
        ),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: form1Controller,
                ),
                TextFormField(
                  controller: form2Controller,
                ),
                TextFormField(
                  controller: form3Controller,
                ),
                ElevatedButton(
                  onPressed: () {
                    formState.add(
                      form1Controller.text,
                      form2Controller.text,
                      form3Controller.text,
                    );
                  },
                  child: const Text('計算'),
                ),
                Text(form.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
