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
final counterProvider = StateNotifierProvider<CounterController, int>(
    (ref) => CounterController(ref.read));

class CounterController extends StateNotifier<int> {
  CounterController(this._read) : super(0);

  final Reader _read;

  void increment() => state++; // カウントアップ
  void decrement() => state--; // カウントダウン
  void reset() => state = 0; // カウントを0に

  // shared_preferencesからデータ読み込み
  Future<void> getCountPrefs() async {
    state = _read(sharedPreferencesProvider).getInt('counter') ?? 0;
  }

  // shared_preferencesにデータ保存
  Future<void> setCountPrefs() async {
    _read(sharedPreferencesProvider).setInt('counter', state);
  }
}

// BMI計算アプリ用プロバイダ
final resultProvider = StateNotifierProvider<ResultController, String>(
    (ref) => ResultController(ref.read));

class ResultController extends StateNotifier<String> {
  ResultController(this._read) : super('');

  final Reader _read;

  void calculate(String height, String weight) {
    //TODO 数字以外が入力された時の処理をどうするか

    // try-cacthで数字以外の時のエラー回避
    // try {
    //   double a = double.parse(height);
    //   double b = double.parse(weight);
    //   state = (b / (a * a / 10000)).toStringAsFixed(2);
    // } catch (e) {
    //   return; //TODO エラーを画面に返すべき
    // }
    double a = double.parse(height);
    double b = double.parse(weight);
    state = (b / (a * a / 10000)).toStringAsFixed(2);
  }

  // shared_preferencesからデータ読み込み
  Future<List> getFormListPrefs() async {
    final List formList =
        _read(sharedPreferencesProvider).getStringList('form') ?? ['', '', ''];
    state = formList[0];
    return formList;
  }

  // shared_preferencesにデータ保存
  Future<void> setFormPrefs(String height, String weight) async {
    _read(sharedPreferencesProvider)
        .setStringList('form', [state, height, weight]);
  }
}

// BMI履歴用プロバイダ
final listProvider = StateNotifierProvider.autoDispose<ListController, List>(
    (ref) => ListController(ref.read));

class ListController extends StateNotifier<List> {
  ListController(this._read) : super([]);

  final Reader _read;
  // shared_preferencesからデータを読み込み
  Future<void> getListprefs() async {
    if (_read(sharedPreferencesProvider).getStringList('form') != null) {
      state.add(_read(sharedPreferencesProvider).getStringList('form'));
    }
  }

  // 保存されたデータを削除
  Future<void> clearListPrefs(key) async {
    await _read(sharedPreferencesProvider).remove(key);
  }
}
