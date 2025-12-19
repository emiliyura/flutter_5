import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../booking/models/room.dart';
import '../providers/favorites_provider.dart';

class RoomCard extends ConsumerWidget {
  final Room room;
  final ValueChanged<Room> onBook;

  const RoomCard({Key? key, required this.room, required this.onBook}) : super(key: key);

  void _navigateToDetail(BuildContext context) {
    context.push('/room/${room.id}');
  }

  void _toggleFavorite(WidgetRef ref) {
    ref.read(favoritesProviderProvider.notifier).toggleFavorite(room.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProviderProvider).contains(room.id);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        borderRadius: BorderRadius.circular(12),
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
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorite(ref),
                  tooltip: isFavorite ? 'Удалить из избранного' : 'Добавить в избранное',
                ),
                room.isBooked
                    ? Chip(label: const Text('Забронирован'), backgroundColor: Colors.red.shade100)
                    : ElevatedButton(onPressed: () => onBook(room), child: const Text('Забронировать')),
                const SizedBox(height: 8),
              ],
            )
          ],
        ),
        ),
      ),
    );
  }
  String _getRoomImageUrl(String roomId) {
    switch (roomId) {
      case 'r1':
        return 'https://avatars.mds.yandex.net/get-vertis-journal/4080458/XXXL.webp_1706519116815/1200x1200';
      case 'r2':
        return 'https://avatars.mds.yandex.net/get-vertis-journal/4220003/XXXL_4.webp_1706538708024/845x845';
      case 'r3':
        return 'https://avatars.mds.yandex.net/get-vertis-journal/4471904/XXXL-3.jpeg_1706517281762/845x845';
      case 'r4':
        return 'https://avatars.mds.yandex.net/get-vertis-journal/4465444/hostel_komnata.jpeg_1706517383201/845x845';
      case 'r5':
        return 'https://avatars.mds.yandex.net/get-vertis-journal/4465444/bez_okon.jpeg_1706517513201/845x845';
      default:
        return 'https://avatars.mds.yandex.net/get-vertis-journal/4212087/standart.jpeg_1706518084136/845x845';
    }
  }
}


