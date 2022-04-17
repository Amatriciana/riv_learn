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
    double a = double.parse(height);
    double b = double.parse(weight);
    state = b / (a * a / 10000);
  }

  Future<void> getResultPrefs() async {
    state = _refRead(sharedPreferencesProvider).getDouble('result') ?? 0;
  }

  // Future<String> getFormPrefs(key) async {
  //   final String value;
  //   value = _refRead(sharedPreferencesProvider).getString(key) ?? '';
  //   return value;
  // }

  // TODO 上のStringと下のMapどっちがいいか

  Future<Map<String, String>> getFormMapPrefs() async {
    final Map<String, String> valueMap = {
      'height': _refRead(sharedPreferencesProvider).getString('height') ?? '',
      'weight': _refRead(sharedPreferencesProvider).getString('weight') ?? '',
    };

    return valueMap;
  }

  Future<void> setFormPrefs(String height, String weight) async {
    _refRead(sharedPreferencesProvider).setString('height', height);
    _refRead(sharedPreferencesProvider).setString('weight', weight);
    _refRead(sharedPreferencesProvider).setDouble('result', state);
  }
}

// BMI履歴用プロバイダ
final listProvider = StateNotifierProvider((ref) => ListController(ref.read));

class ListController<List> extends StateNotifier {
  ListController(this._refRead) : super([]);

  final Reader _refRead;

  void initialize() {
    state = [];
  }

  Future<void> getHeightPrefs() async {
    state.add(_refRead(sharedPreferencesProvider).getString('height') ?? 'aaa');
    state.add(_refRead(sharedPreferencesProvider).getString('weight') ?? 'iii');
  }
}
