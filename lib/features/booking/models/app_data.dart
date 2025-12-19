import 'room.dart';
import 'booking.dart';

// Простое хранилище данных в памяти без паттерна Singleton
class AppData {
  // Список номеров
  static final List<Room> rooms = [
    Room(
      id: 'r1',
      title: 'Стандартный однокомнатный',
      price: 50.0,
      beds: 1,
      amenities: ['Wi-Fi', 'Телевизор'],
    ),
    Room(
      id: 'r2',
      title: 'Двухместный улучшенный',
      price: 80.0,
      beds: 2,
      amenities: ['Wi-Fi', 'Кондиционер'],
    ),
    Room(
      id: 'r3',
      title: 'Люкс',
      price: 150.0,
      beds: 2,
      amenities: ['Wi-Fi', 'Кондиционер', 'Мини-бар'],
    ),
    Room(
      id: 'r4',
      title: 'Семейный номер',
      price: 120.0,
      beds: 3,
      amenities: ['Wi-Fi', 'Кондиционер', 'Балкон', 'Детская кроватка'],
    ),
    Room(
      id: 'r5',
      title: 'Президентский люкс',
      price: 300.0,
      beds: 2,
      amenities: [
        'Wi-Fi',
        'Кондиционер',
        'Мини-бар',
        'Джакузи',
        'Панорамные окна',
        'Персональный консьерж'
      ],
    ),
  ];

  // Список бронирований
  static final List<Booking> bookings = [];

  // Получить отсортированные номера по цене
  static List<Room> getRoomsSortedByPrice(bool ascending) {
    final copy = [...rooms];
    copy.sort((a, b) =>
        ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
    return copy;
  }

  // Добавить бронирование
  static void addBooking(Booking booking) {
    bookings.add(booking);
  }

  // Отменить бронирование
  static void cancelBooking(String bookingId) {
    bookings.removeWhere((b) => b.id == bookingId);
  }
}

