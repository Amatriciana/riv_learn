import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'controller.dart';

class BmiHistory extends HookConsumerWidget {
  const BmiHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(listProvider);
    final listState = ref.watch(listProvider.notifier);

    useEffect(() {
      listState.getListprefs();
      print(list);
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculate History'),
      ),
      body: ListView.builder(
        itemCount: listState.state.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
            ),
            child: ListTile(
              title: Text(
                '身長: ${listState.state[index][1]}  '
                '体重: ${listState.state[index][2]}  '
                'BMI: ${listState.state[index][0]}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                print(list);
              },
            ),
          );
        },
      ),
    );
  }
}
