# Руководство по использованию Clean Architecture

## Быстрый старт

### 1. Инициализация

В `main.dart` уже настроена инициализация:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();  // Старый DI (для совместимости)
  await setupAppModule();        // Новый Clean Architecture DI
  runApp(const MyApp());
}
```

### 2. Использование Use Cases в провайдерах

```dart
import '../../core/di/app_module.dart';
import '../../domain/usecases/get_rooms_usecase.dart';

// Получение Use Case через DI
final useCase = getIt<GetRoomsUseCase>();

// Использование
final rooms = await useCase();
```

### 3. Использование Use Cases в экранах

```dart
import '../../core/di/app_module.dart';
import '../../domain/usecases/create_booking_usecase.dart';

// В методе экрана
final createBookingUseCase = getIt<CreateBookingUseCase>();
try {
  final booking = await createBookingUseCase(
    room: room,
    guestName: guestName,
    checkIn: checkIn,
    checkOut: checkOut,
  );
  // Обработка успеха
} catch (e) {
  // Обработка ошибки
}
```

---

## Структура слоев

### Domain Layer

**Принцип**: Абсолютно чистый слой, не зависит от Flutter или внешних библиотек.

#### Entities
```dart
// domain/entities/room.dart
class Room {
  final String id;
  final String title;
  // ... другие поля
}
```

#### Use Cases
```dart
// domain/usecases/get_rooms_usecase.dart
class GetRoomsUseCase {
  final RoomsRepository _repository;
  
  GetRoomsUseCase(this._repository);
  
  Future<List<Room>> call() async {
    return await _repository.getRooms();
  }
}
```

#### Repository Interfaces
```dart
// domain/repositories/rooms_repository.dart
abstract class RoomsRepository {
  Future<List<Room>> getRooms();
  Future<Room?> getRoomById(String roomId);
}
```

---

### Data Layer

**Принцип**: Реализует интерфейсы из Domain Layer, работает с внешними источниками данных.

#### DTOs
```dart
// data/models/room_dto.dart
class RoomDto {
  // Поля для сериализации
  
  // Преобразование в Entity
  Room toEntity() {
    return Room(...);
  }
  
  // Создание из Entity
  factory RoomDto.fromEntity(Room room) {
    return RoomDto(...);
  }
}
```

#### Repository Implementations
```dart
// data/repositories/rooms_repository_impl.dart
class RoomsRepositoryImpl implements RoomsRepository {
  final RoomsRemoteDataSource _remoteDataSource;
  final RoomsLocalDataSource _localDataSource;
  
  @override
  Future<List<Room>> getRooms() async {
    // Логика получения данных
    final dtos = await _remoteDataSource.getRooms();
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}
```

---

### Presentation Layer

**Принцип**: Только UI и состояние, использует Use Cases для бизнес-логики.

#### Providers
```dart
// presentation/providers/rooms_provider.dart
@riverpod
class RoomsNotifier extends _$RoomsNotifier {
  @override
  RoomsState build() {
    _loadRooms();
    return RoomsState();
  }
  
  Future<void> _loadRooms() async {
    final useCase = getIt<GetRoomsUseCase>();
    final rooms = await useCase();
    state = state.copyWith(rooms: rooms);
  }
}
```

---

## Правила работы с архитектурой

### ✅ DO (Делать)

1. **Использовать Use Cases в UI Layer**
   ```dart
   final useCase = getIt<GetRoomsUseCase>();
   final rooms = await useCase();
   ```

2. **Создавать новые Use Cases для бизнес-операций**
   ```dart
   class CancelBookingUseCase {
     final BookingsRepository _repository;
     // ...
   }
   ```

3. **Использовать DTOs для работы с данными**
   ```dart
   RoomDto.fromJson(json).toEntity()
   ```

4. **Реализовывать интерфейсы репозиториев в Data Layer**

### ❌ DON'T (Не делать)

1. **Не использовать репозитории напрямую в UI Layer**
   ```dart
   // ❌ Плохо
   final repository = getIt<RoomsRepository>();
   final rooms = await repository.getRooms();
   
   // ✅ Хорошо
   final useCase = getIt<GetRoomsUseCase>();
   final rooms = await useCase();
   ```

2. **Не добавлять зависимости от Flutter в Domain Layer**
   ```dart
   // ❌ Плохо
   import 'package:flutter/material.dart';
   
   // ✅ Хорошо
   // Нет импортов Flutter
   ```

3. **Не смешивать бизнес-логику с UI**
   ```dart
   // ❌ Плохо - валидация в экране
   if (guestName.isEmpty) {
     showError('Имя не может быть пустым');
   }
   
   // ✅ Хорошо - валидация в Use Case
   final booking = await createBookingUseCase(...);
   ```

---

## Добавление новой функциональности

### Пример: Добавление отмены бронирования

#### 1. Создать Use Case в Domain Layer

```dart
// domain/usecases/cancel_booking_usecase.dart
class CancelBookingUseCase {
  final BookingsRepository _repository;
  
  CancelBookingUseCase(this._repository);
  
  Future<void> call(String bookingId) async {
    // Бизнес-правила валидации
    if (bookingId.isEmpty) {
      throw Exception('ID бронирования не может быть пустым');
    }
    
    await _repository.cancelBooking(bookingId);
  }
}
```

#### 2. Зарегистрировать в DI

```dart
// core/di/app_module.dart
getIt.registerLazySingleton<CancelBookingUseCase>(
  () => CancelBookingUseCase(getIt<BookingsRepository>()),
);
```

#### 3. Использовать в UI

```dart
// В провайдере или экране
final cancelUseCase = getIt<CancelBookingUseCase>();
await cancelUseCase(bookingId);
```

---

## Тестирование

### Unit-тесты для Use Cases

```dart
// test/domain/usecases/get_rooms_usecase_test.dart
void main() {
  test('should return rooms from repository', () async {
    // Arrange
    final mockRepository = MockRoomsRepository();
    final useCase = GetRoomsUseCase(mockRepository);
    
    // Act
    final result = await useCase();
    
    // Assert
    expect(result, isA<List<Room>>());
  });
}
```

### Unit-тесты для Repositories

```dart
// test/data/repositories/rooms_repository_impl_test.dart
void main() {
  test('should return rooms from remote data source', () async {
    // Arrange
    final mockRemote = MockRoomsRemoteDataSource();
    final mockLocal = MockRoomsLocalDataSource();
    final repository = RoomsRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
    
    // Act
    final result = await repository.getRooms();
    
    // Assert
    expect(result, isA<List<Room>>());
  });
}
```

---

## Миграция существующего кода

### Шаг 1: Определить бизнес-операцию
- Что делает код?
- Какие данные нужны?
- Какие данные возвращаются?

### Шаг 2: Создать Use Case
- Вынести бизнес-логику в Use Case
- Добавить валидацию

### Шаг 3: Обновить UI
- Заменить прямые вызовы репозиториев на Use Cases
- Обновить провайдеры

### Шаг 4: Тестирование
- Написать тесты для Use Case
- Проверить работу UI

---

## FAQ

**Q: Можно ли использовать старые провайдеры вместе с новыми?**
A: Да, во время миграции можно использовать оба подхода. Постепенно мигрируйте функциональность.

**Q: Как добавить новый источник данных?**
A: Создайте новый DataSource в `data/datasources/`, реализуйте интерфейс, обновите Repository Implementation.

**Q: Где хранить константы и утилиты?**
A: В `core/utils/` для общих утилит, в `domain/` для бизнес-констант.

**Q: Как обрабатывать ошибки?**
A: Use Cases должны выбрасывать исключения, UI Layer их обрабатывает и отображает пользователю.

---

## Полезные ссылки

- [CLEAN_ARCHITECTURE.md](./CLEAN_ARCHITECTURE.md) - Полная документация архитектуры
- [REFACTORING_SUMMARY.md](./REFACTORING_SUMMARY.md) - Резюме выполненной работы
