import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

/// Реализация репозитория для работы с пользователями
/// Временная реализация с хранением в памяти (для демонстрации)
class UserRepositoryImpl implements UserRepository {
  User? _currentUser;
  final Map<String, String> _credentials = {}; // email -> password

  @override
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _currentUser;
  }

  @override
  Future<User> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = user;
    return user;
  }

  @override
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Простая проверка (в реальном приложении здесь будет запрос к API)
    if (_credentials[email] == password) {
      // Находим пользователя или создаем нового
      if (_currentUser == null || _currentUser!.email != email) {
        _currentUser = User(
          id: email,
          name: email.split('@')[0],
          email: email,
          phone: '+7 (999) 999-99-99',
          city: 'Москва',
          registrationDate: DateTime.now(),
        );
      }
      return true;
    }
    return false;
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Сохраняем credentials
    _credentials[email] = password;
    
    // Создаем пользователя
    final user = User(
      id: email,
      name: name,
      email: email,
      phone: '+7 (999) 999-99-99',
      city: 'Москва',
      registrationDate: DateTime.now(),
    );
    
    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser = null;
  }
}
