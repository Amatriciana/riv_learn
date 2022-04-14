import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bmi_calc.dart';

final listStreamProvider = FutureProvider((ref) async {
  final prefs = await SharedPreferences.getInstance();
  List formList = [];
  formList.add(prefs.getString('height') ?? 'aaa');
  formList.add(prefs.getString('weight') ?? 'iii');

  return formList;
});

class BmiHistory extends HookConsumerWidget {
  const BmiHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listStream = ref.watch(listStreamProvider);
    return listStream.when(
      data: (data) => Scaffold(
        appBar: AppBar(
          title: const Text('BMI Calculate History'),
        ),
        body: ListView.builder(
          itemCount: data.length,
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
                  data[index],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  print(data[index]);
                },
              ),
            );
          },
        ),
      ),
      error: (error, stack) => const Text('error'),
      loading: () => const Center(child: CupertinoActivityIndicator()),
    );
  }
}
