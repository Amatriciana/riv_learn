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
final counterProvider =
    StateNotifierProvider((ref) => CounterController(ref.read));

class CounterController extends StateNotifier {
  CounterController(this._refRead) : super(0);

  final Reader _refRead;

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;

  Future<void> getCountPrefs() async {
    state = _refRead(sharedPreferencesProvider).getInt('counter') ?? 0;
  }

  Future<void> setCountPrefs() async {
    _refRead(sharedPreferencesProvider).setInt('counter', state);
  }
}

// BMI計算アプリ用プロバイダ
final resultProvider =
    StateNotifierProvider((ref) => ResultController(ref.read));

class ResultController extends StateNotifier {
  ResultController(this._refRead) : super(0);

  final Reader _refRead;

  void calculate(String height, String weight) {
    //TODO 数字以外が入力された時の処理をどうするか
    double a = double.parse(height);
    double b = double.parse(weight);
    state = (b / (a * a / 10000)).toStringAsFixed(2);
    print((b / (a * a / 10000)).toString());
  }

  Future<List> getFormListPrefs() async {
    final List formList =
        _refRead(sharedPreferencesProvider).getStringList('form') ??
            ['', '', ''];
    state = formList[0];
    return formList;
  }

  Future<void> setFormPrefs(String height, String weight) async {
    _refRead(sharedPreferencesProvider)
        .setStringList('form', [state, height, weight]);
  }
}

// BMI履歴用プロバイダ
final listProvider =
    StateNotifierProvider.autoDispose((ref) => ListController<List>(ref.read));

class ListController<List> extends StateNotifier {
  ListController(this._refRead) : super([]);

  final Reader _refRead;

  Future<void> getListprefs() async {
    if (_refRead(sharedPreferencesProvider).getStringList('from') != null) {
      state.add(_refRead(sharedPreferencesProvider).getStringList('form'));
    }
  }
}

  // Future<void> getHeightPrefs() async {
  //   if (_refRead(sharedPreferencesProvider).getString('height') != null) {
  //     state.add(_refRead(sharedPreferencesProvider).getString('height'));
  //   }
  //   if (_refRead(sharedPreferencesProvider).getString('weight') != null) {
  //     state.add(_refRead(sharedPreferencesProvider).getString('weight'));
  //   }
  // }}

