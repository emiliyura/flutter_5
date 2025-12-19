import 'package:drift/drift.dart';
import '../../domain/entities/user.dart' as domain;
import '../../domain/repositories/user_repository.dart';
import '../database/app_database.dart';

/// Реализация репозитория для работы с пользователями с использованием Drift
class UserRepositoryImpl implements UserRepository {
  final AppDatabase _db;
  domain.User? _currentUser;

  UserRepositoryImpl(this._db);

  @override
  Future<domain.User?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<domain.User> updateUser(domain.User user) async {
    final userEntity = await _db.getUserByEmail(user.email);
    if (userEntity != null) {
      final companion = UsersCompanion(
        id: Value(userEntity.id),
        name: Value(user.name),
        email: Value(user.email),
        phone: Value(user.phone),
        city: Value(user.city),
      );
      await _db.updateUser(companion);
      _currentUser = user;
      return user;
    }
    throw Exception('User not found');
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      final userEntity = await _db.getUserByEmail(email.toLowerCase());
      if (userEntity != null && userEntity.passwordHash == password) {
        _currentUser = domain.User(
          id: userEntity.email,
          name: userEntity.name,
          email: userEntity.email,
          phone: userEntity.phone,
          city: userEntity.city,
          registrationDate: userEntity.registrationDate,
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<domain.User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final emailLower = email.toLowerCase();
    
    // Проверяем, существует ли пользователь
    final existingUser = await _db.getUserByEmail(emailLower);
    if (existingUser != null) {
      throw Exception('User already exists');
    }
    
    // Создаем нового пользователя в базе данных
    final companion = UsersCompanion.insert(
      name: name,
      email: emailLower,
      passwordHash: password,
    );
    
    await _db.createUser(companion);
    
    // Получаем созданного пользователя
    final userEntity = await _db.getUserByEmail(emailLower);
    if (userEntity == null) {
      throw Exception('Failed to create user');
    }
    
    final user = domain.User(
      id: userEntity.email,
      name: userEntity.name,
      email: userEntity.email,
      phone: userEntity.phone,
      city: userEntity.city,
      registrationDate: userEntity.registrationDate,
    );
    
    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }
}










