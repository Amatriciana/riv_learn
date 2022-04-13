import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'counter.dart';
import 'bmi_calc.dart';

final bottomNavigationProvider =
    StateProvider<BottomNav>((ref) => BottomNav.counter);

enum BottomNav {
  counter,
  bmiCalc,
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomNavState = ref.watch(bottomNavigationProvider);
    final bottomNavState2 = ref.watch(bottomNavigationProvider.notifier);

    final _pageList = [
      const CounterApp(),
      const BmiCalcApp(),
    ];

    return MaterialApp(
        home: Scaffold(
      body: _pageList[bottomNavState.index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int selectIndex) {
          bottomNavState2.state = BottomNav.values[selectIndex];
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'add',
          ),
        ],
      ),
    ));
  }
}
