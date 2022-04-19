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
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculate History'),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: UniqueKey(),
            child: Column(
              children: [
                Container(
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
                      'No.[${list[index][0]}]  '
                      '身長: ${list[index][2]}  '
                      '体重: ${list[index][3]}  '
                      'BMI: ${list[index][1]}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onDismissed: (direction) {
              listState.clearListPrefs(list[index][0]);
            },
          );
        },
      ),
    );
  }
}
