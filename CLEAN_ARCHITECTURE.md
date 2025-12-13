# Clean Architecture - Документация

## Анализ сложности приложения

### Критерии оценки:

1. **Количество экранов и бизнес-сценариев**: 13 экранов
   - Главная, Список номеров, Детали номера
   - Бронирование (3 шага), Список бронирований
   - Профиль, Редактирование профиля
   - Избранное, Программа лояльности, Настройки
   - Авторизация, Регистрация
   - **Оценка**: Средняя сложность

2. **Жизненный цикл и стабильность требований**: 
   - Приложение находится в активной разработке
   - Требования могут изменяться
   - **Оценка**: Средняя стабильность

3. **Количество и разнородность источников данных**:
   - Локальное хранилище (память, в будущем - БД)
   - Удаленный API (моковые данные)
   - Кэширование данных
   - **Оценка**: Средняя сложность

4. **Требования к тестируемости и командной работе**:
   - Необходимость unit-тестов для бизнес-логики
   - Возможность работы нескольких разработчиков
   - **Оценка**: Высокие требования

### Итоговая оценка: **Средняя сложность**
Clean Architecture оправдан для данного приложения.

---

## Структура Clean Architecture

### Слои архитектуры

```
lib/
├── domain/              # Domain Layer (Чистый слой)
│   ├── entities/        # Бизнес-модели
│   ├── repositories/    # Абстрактные интерфейсы
│   └── usecases/        # Сценарии использования
│
├── data/                # Data Layer
│   ├── models/          # DTO (Data Transfer Objects)
│   ├── datasources/     # Источники данных (Local/Remote)
│   └── repositories/    # Реализации репозиториев
│
├── presentation/        # UI Layer (Presentation Layer)
│   ├── screens/         # Экраны приложения
│   ├── widgets/         # Переиспользуемые виджеты
│   └── providers/       # State Management (Riverpod)
│
└── core/                # Общие компоненты
    ├── di/              # Dependency Injection
    └── utils/           # Утилиты
```

---

## Domain Layer (Предметная область)

### Принципы:
- ✅ Абсолютно чистый слой без зависимостей от Flutter
- ✅ Содержит только бизнес-логику
- ✅ Не зависит от других слоев

### Структура:

#### Entities (Сущности)
- `Room` - Номер отеля
- `Booking` - Бронирование
- `User` - Пользователь
- `LoyaltyOperation` - Операция лояльности

#### Repositories (Интерфейсы)
- `RoomsRepository` - Работа с номерами
- `BookingsRepository` - Работа с бронированиями
- `FavoritesRepository` - Работа с избранным
- `LoyaltyRepository` - Работа с программой лояльности
- `UserRepository` - Работа с пользователями

#### Use Cases (Сценарии использования)
- `GetRoomsUseCase` - Получение списка номеров
- `CreateBookingUseCase` - Создание бронирования
- `GetBookingsUseCase` - Получение списка бронирований
- `EarnLoyaltyPointsUseCase` - Начисление баллов лояльности

---

## Data Layer (Данные)

### Принципы:
- ✅ Реализует интерфейсы из Domain Layer
- ✅ Содержит DTO для работы с внешними источниками
- ✅ Инкапсулирует работу с API и локальной БД

### Структура:

#### Models (DTO)
- `RoomDto` - DTO для номера
- `BookingDto` - DTO для бронирования
- Методы `toEntity()` и `fromEntity()` для преобразования

#### Data Sources
- `RoomsRemoteDataSource` - Удаленный источник данных
- `RoomsLocalDataSource` - Локальный источник данных

#### Repositories (Реализации)
- `RoomsRepositoryImpl` - Реализация репозитория номеров
- `BookingsRepositoryImpl` - Реализация репозитория бронирований
- `FavoritesRepositoryImpl` - Реализация репозитория избранного
- `LoyaltyRepositoryImpl` - Реализация репозитория лояльности
- `UserRepositoryImpl` - Реализация репозитория пользователей

---

## Presentation Layer (UI Layer)

### Принципы:
- ✅ Только отображение и обработка пользовательских действий
- ✅ Не содержит бизнес-логики
- ✅ Использует Use Cases для выполнения операций

### Структура:

#### Screens
- Экраны приложения (13 экранов)

#### Widgets
- Переиспользуемые виджеты

#### Providers (State Management)
- Riverpod провайдеры для управления состоянием UI
- Используют Use Cases для получения данных

---

## Dependency Injection

### Настройка в `core/di/app_module.dart`:

1. **Data Sources** - Регистрируются как LazySingleton
2. **Repositories** - Регистрируются как LazySingleton (интерфейсы и реализации)
3. **Use Cases** - Регистрируются как LazySingleton

### Принцип инверсии зависимостей:
- UI Layer зависит от Domain Layer (Use Cases)
- Data Layer зависит от Domain Layer (интерфейсы репозиториев)
- Domain Layer не зависит ни от чего

---

## Преимущества Clean Architecture

1. **Тестируемость**: Легко тестировать бизнес-логику изолированно
2. **Независимость**: Изменения в UI или Data не влияют на Domain
3. **Масштабируемость**: Легко добавлять новые функции
4. **Поддерживаемость**: Четкое разделение ответственности
5. **Гибкость**: Легко менять источники данных без изменения бизнес-логики

---

## Миграция существующего кода

### Этапы миграции:

1. ✅ Создана структура Domain Layer
2. ✅ Создана структура Data Layer
3. ⏳ Рефакторинг UI Layer (использование Use Cases)
4. ⏳ Обновление dependency injection
5. ⏳ Миграция существующих экранов

### Текущий статус:
- Domain Layer: ✅ Готов
- Data Layer: ✅ Готов
- UI Layer: ⏳ В процессе рефакторинга

---

## Примеры использования

### Использование Use Case в UI:

```dart
// В экране или провайдере
final getRoomsUseCase = getIt<GetRoomsUseCase>();
final rooms = await getRoomsUseCase();

final createBookingUseCase = getIt<CreateBookingUseCase>();
final booking = await createBookingUseCase(
  room: room,
  guestName: guestName,
  checkIn: checkIn,
  checkOut: checkOut,
);
```

### Зависимости:
```
UI Layer → Use Cases → Repository Interfaces
                              ↑
Data Layer → Repository Implementations
```

---

## Следующие шаги

1. Завершить рефакторинг UI Layer
2. Обновить существующие экраны для использования Use Cases
3. Написать unit-тесты для Use Cases
4. Написать unit-тесты для Repositories
5. Интегрировать реальный API вместо моковых данных
