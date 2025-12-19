import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/service_locator.dart';
import '../../../shared/state/user_state.dart';
import '../../../domain/repositories/user_repository.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthProvider extends _$AuthProvider {
  UserState? _userState;
  UserRepository? _userRepository;

  @override
  bool build() {
    _userState = getIt<UserState>();
    _userRepository = getIt<UserRepository>();
    return _userState?.isAuthenticated ?? false;
  }

  bool get isAuthenticated => state;

  Future<bool> login(String email, String password) async {
    if (_userRepository == null || _userState == null) return false;
    
    try {
      final success = await _userRepository!.login(email, password);
      if (success) {
        final user = await _userRepository!.getCurrentUser();
        if (user != null) {
          _userState!.setUserData(
            name: user.name,
            email: user.email,
            phone: user.phone,
            city: user.city,
            registrationDate: user.registrationDate,
          );
          state = true;
        }
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    if (_userRepository == null || _userState == null) return false;
    
    try {
      final user = await _userRepository!.register(
        name: name,
        email: email,
        password: password,
      );
      
      _userState!.setUserData(
        name: user.name,
        email: user.email,
        phone: user.phone,
        city: user.city,
        registrationDate: user.registrationDate,
      );
      state = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _userRepository?.logout();
    _userState?.logout();
    state = false;
  }
}

