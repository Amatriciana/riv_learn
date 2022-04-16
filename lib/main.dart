import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'counter.dart';
import 'bmi_calc.dart';
import 'bmi_history.dart';
import 'controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late final SharedPreferences sharedPreferences;
  await Future.wait(
    [
      Future(() async {
        sharedPreferences = await SharedPreferences.getInstance();
      }),
    ],
  );
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences)
      ],
      child: Consumer(
        builder: (context, ref, child) {
          return child!;
        },
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomNav = ref.watch(bottomNavProvider);
    final bottomNavState = ref.watch(bottomNavProvider.notifier);

    final List _pageList = [
      const CounterApp(),
      const BmiCalcApp(),
      const BmiHistory(),
    ];

    return MaterialApp(
      home: Scaffold(
        body: _pageList[bottomNav.index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomNav.index,
          onTap: (int selectPage) {
            bottomNavState.state = BottomNav.values[selectPage];
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'カウンター',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'BMI計算',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'BMI履歴',
            ),
          ],
        ),
      ),
    );
  }
}
