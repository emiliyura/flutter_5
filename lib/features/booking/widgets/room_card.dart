import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../booking/models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final ValueChanged<Room> onBook;

  const RoomCard({Key? key, required this.room, required this.onBook}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: _getRoomImageUrl(room.id),
                width: 100,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 100,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 100,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.hotel,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Мест: ${room.beds} • ${room.amenities.join(', ')}'),
                  const SizedBox(height: 6),
                  Text('Цена: \$${room.price.toStringAsFixed(2)}/сут', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Column(
              children: [
                room.isBooked
                    ? Chip(label: const Text('Забронирован'), backgroundColor: Colors.red.shade100)
                    : ElevatedButton(onPressed: () => onBook(room), child: const Text('Забронировать')),
                const SizedBox(height: 8),
              ],
            )
          ],
        ),
      ),
    );
  }
  String _getRoomImageUrl(String roomId) {
    switch (roomId) {
      case 'r1':
        return 'https://media-cdn.tripadvisor.com/media/photo-s/0c/de/a0/74/photo1jpg.jpg';
      case 'r2':
        return 'https://augustnews.ru/wp-content/uploads/2019/03/kvartira-priton-komnata-grjaz-ne-ubrano.jpg';
      case 'r3':
        return 'https://static.tildacdn.com/tild3439-3462-4232-a465-656662373336/nazional_6.jpg';
      case 'r4':
        return 'https://www.hotel-moscow.ru/storage/media/fc330849-b5f8-4f49-b5ad-10581931519a.jpg';
      case 'r5':
        return 'https://cityparkhotels.ru/wp-content/uploads/2021/07/DSF1210_1_2.jpg';
      default:
        return 'https://cityparkhotels.ru/wp-content/uploads/2021/07/DSF1210_1_2.jpg';
    }
  }
}


