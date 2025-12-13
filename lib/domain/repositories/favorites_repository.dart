/// Абстрактный интерфейс репозитория для работы с избранным
/// Определяется в Domain Layer, реализуется в Data Layer
abstract class FavoritesRepository {
  /// Получить список ID избранных номеров
  Future<Set<String>> getFavoriteRoomIds();

  /// Добавить номер в избранное
  Future<void> addToFavorites(String roomId);

  /// Удалить номер из избранного
  Future<void> removeFromFavorites(String roomId);

  /// Переключить состояние избранного
  Future<void> toggleFavorite(String roomId);

  /// Проверить, находится ли номер в избранном
  Future<bool> isFavorite(String roomId);
}
