import '../entities/user.dart';

/// Абстрактный интерфейс репозитория для работы с пользователями
/// Определяется в Domain Layer, реализуется в Data Layer
abstract class UserRepository {
  /// Получить текущего пользователя
  Future<User?> getCurrentUser();

  /// Обновить данные пользователя
  Future<User> updateUser(User user);

  /// Войти в систему
  Future<bool> login(String email, String password);

  /// Зарегистрироваться
  Future<User> register({
    required String name,
    required String email,
    required String password,
  });

  /// Выйти из системы
  Future<void> logout();
}
