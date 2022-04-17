import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'controller.dart';

class BmiCalcApp extends HookConsumerWidget {
  const BmiCalcApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heightTextEditingController = useTextEditingController();
    final weightTextEditingController = useTextEditingController();

    final calculate = ref.watch(resultProvider.notifier);
    final result = ref.watch(resultProvider);

    // 初期値代入
    useEffect(() {
      Future(() async {
        // heightTextEditingController.text =
        //     await calculate.getFormPrefs('height');
        // weightTextEditingController.text =
        //     await calculate.getFormPrefs('weight');

        // TODO 上のStringと下のMapとどっちがいいか

        final valueMap = await calculate.getFormMapPrefs(); // TODO なぜawaitが要るのか
        heightTextEditingController.text = valueMap['height'].toString();
        weightTextEditingController.text = valueMap['weight'].toString();

        calculate.getResultPrefs();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMICalculator'),
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
                calculate.calculate(
                  heightTextEditingController.text,
                  weightTextEditingController.text,
                );
                calculate.setFormPrefs(
                  heightTextEditingController.text,
                  weightTextEditingController.text,
                );
              },
            ),
            Text('Result: $result'),
          ],
        ),
      ),
    );
  }
}
