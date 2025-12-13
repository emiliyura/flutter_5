import '../../data/datasources/rooms_local_data_source.dart';
import '../../data/datasources/rooms_local_data_source_impl.dart';
import '../../data/datasources/rooms_remote_data_source.dart';
import '../../data/datasources/rooms_remote_data_source_impl.dart';
import '../../data/repositories/bookings_repository_impl.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../data/repositories/loyalty_repository_impl.dart';
import '../../data/repositories/rooms_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/loyalty_repository.dart';
import '../../domain/repositories/rooms_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/earn_loyalty_points_usecase.dart';
import '../../domain/usecases/get_bookings_usecase.dart';
import '../../domain/usecases/get_rooms_usecase.dart';
import '../service_locator.dart' show getIt; // Используем общий getIt

// Экспортируем getIt для использования в других модулях
export '../service_locator.dart' show getIt;

/// Настройка Dependency Injection для Clean Architecture
/// 
/// Регистрирует все зависимости согласно принципам инверсии зависимостей:
/// - Data Sources (конкретные реализации)
/// - Repositories (интерфейсы и их реализации)
/// - Use Cases (зависят от интерфейсов репозиториев)
Future<void> setupAppModule() async {
  // ========== Data Sources ==========
  
  // Rooms Data Sources
  getIt.registerLazySingleton<RoomsRemoteDataSource>(
    () => RoomsRemoteDataSourceImpl(),
  );
  
  getIt.registerLazySingleton<RoomsLocalDataSource>(
    () => RoomsLocalDataSourceImpl(),
  );

  // ========== Repositories ==========
  
  // Rooms Repository
  getIt.registerLazySingleton<RoomsRepository>(
    () => RoomsRepositoryImpl(
      remoteDataSource: getIt<RoomsRemoteDataSource>(),
      localDataSource: getIt<RoomsLocalDataSource>(),
    ),
  );

  // Bookings Repository
  getIt.registerLazySingleton<BookingsRepository>(
    () => BookingsRepositoryImpl(),
  );

  // Favorites Repository
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(),
  );

  // Loyalty Repository
  getIt.registerLazySingleton<LoyaltyRepository>(
    () => LoyaltyRepositoryImpl(),
  );

  // User Repository
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(),
  );

  // ========== Use Cases ==========
  
  // Rooms Use Cases
  getIt.registerLazySingleton<GetRoomsUseCase>(
    () => GetRoomsUseCase(getIt<RoomsRepository>()),
  );

  // Bookings Use Cases
  getIt.registerLazySingleton<GetBookingsUseCase>(
    () => GetBookingsUseCase(getIt<BookingsRepository>()),
  );

  getIt.registerLazySingleton<CreateBookingUseCase>(
    () => CreateBookingUseCase(getIt<BookingsRepository>()),
  );

  // Loyalty Use Cases
  getIt.registerLazySingleton<EarnLoyaltyPointsUseCase>(
    () => EarnLoyaltyPointsUseCase(getIt<LoyaltyRepository>()),
  );
}

/// Сброс всех зависимостей (для тестирования)
Future<void> resetAppModule() async {
  await getIt.reset();
}
