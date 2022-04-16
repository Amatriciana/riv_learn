import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences用プロバイダ
final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

// ボトムナビゲーター用プロバイダ
final bottomNavProvider = StateProvider<BottomNav>((ref) => BottomNav.counter);
enum BottomNav {
  counter,
  bmiCalc,
  bmiHistory,
}

// カウンターアプリ用プロバイダ
final counterProvider = StateNotifierProvider((ref) => CounterStateNotifier());

class CounterStateNotifier extends StateNotifier {
  CounterStateNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;

  Future<void> getCountPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('counter') ?? 0;
  }

  Future<void> setCountPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', state);
  }
}

// BMI計算アプリ用プロバイダ
final resultProvider =
    StateNotifierProvider((ref) => ResultStateNotifier(ref.read));

class ResultStateNotifier extends StateNotifier {
  ResultStateNotifier(this._refread) : super(0);

  final Reader _refread;

  void calculate(String height, String weight) {
    double a = double.parse(height);
    double b = double.parse(weight);
    state = b / (a * a / 10000);
  }

  Future<void> getResultPrefs() async {
    final prefs = _refread(sharedPreferencesProvider);
    state = prefs.getDouble('result') ?? 0;
  }

  Future<String> getHeightPrefs() async {
    final String height;
    final prefs = _refread(sharedPreferencesProvider);
    height = prefs.getString('height') ?? '';
    print(height);
    return height;
  }

  Future<void> setFormPrefs(String height, String weight) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('height', height);
    prefs.setString('weight', weight);
    prefs.setDouble('result', state);
  }
}
