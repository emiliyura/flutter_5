import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/service_locator.dart';
import '../../../shared/state/user_state.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthProvider extends _$AuthProvider {
  UserState? _userState;

  @override
  bool build() {
    _userState = getIt<UserState>();
    return _userState?.isAuthenticated ?? false;
  }

  bool get isAuthenticated => state;

  Future<bool> login(String email, String password) async {
    // Симуляция проверки учетных данных
    await Future.delayed(const Duration(milliseconds: 500));
    
    final success = _userState?.authenticate(email, password) ?? false;
    if (success) {
      state = true;
    }
    return success;
  }

  Future<bool> register(String name, String email, String password) async {
    // Симуляция регистрации
    await Future.delayed(const Duration(milliseconds: 500));
    
    final success = _userState?.register(name, email, password) ?? false;
    if (success) {
      state = true;
    }
    return success;
  }

  void logout() {
    _userState?.logout();
    state = false;
  }

}

