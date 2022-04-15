import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

final listProvider = StateNotifierProvider((ref) => ListNotifier());

class ListNotifier<List, String> extends StateNotifier {
  ListNotifier() : super([]);

  void initialize() {
    state = ['uuu', 'eee'];
  }

  Future<void> getHeightPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state.add(prefs.getString('height') ?? 'aaa');
    state.add(prefs.getString('weight') ?? 'iii');
  }
}

class BmiHistory extends HookConsumerWidget {
  const BmiHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(listProvider.notifier);
    useEffect(() {
      listState.initialize();
      listState.getHeightPrefs();
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
                listState.state[index],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                print(listState.state[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
