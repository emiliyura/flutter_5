import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/room.dart';
import '../providers/favorites_provider.dart';

class RoomDetailScreen extends ConsumerWidget {
  final Room room;

  const RoomDetailScreen({
    super.key,
    required this.room,
  });

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

  void _toggleFavorite(WidgetRef ref) {
    ref.read(favoritesProviderProvider.notifier).toggleFavorite(room.id);
  }

  void _onBook(BuildContext context) {
    context.go('/booking/step1/${room.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProviderProvider).contains(room.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                room.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: _getRoomImageUrl(room.id),
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.hotel,
                      color: Colors.grey,
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () => _toggleFavorite(ref),
                tooltip: isFavorite ? 'Удалить из избранного' : 'Добавить в избранное',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Цена
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Цена за ночь',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${room.price.toStringAsFixed(2)} ₽',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                          if (room.isBooked)
                            Chip(
                              label: const Text('Забронирован'),
                              backgroundColor: Colors.red.shade100,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Описание
                  Text(
                    'Описание',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Уютный номер с современным дизайном и всеми необходимыми удобствами для комфортного проживания.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  // Характеристики
                  Text(
                    'Характеристики',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    context,
                    Icons.bed,
                    'Количество мест',
                    '${room.beds}',
                  ),
                  const SizedBox(height: 16),
                  // Удобства
                  Text(
                    'Удобства',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: room.amenities.map((amenity) {
                      return Chip(
                        label: Text(amenity),
                        avatar: const Icon(Icons.check_circle, size: 18),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  // Кнопка бронирования
                  if (!room.isBooked)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _onBook(context),
                        icon: const Icon(Icons.book_online),
                        label: const Text(
                          'Забронировать номер',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}













