import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/loyalty_provider.dart';

class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loyaltyState = ref.watch(loyaltyProviderProvider);
    final currentPoints = loyaltyState.currentPoints;
    final operations = loyaltyState.operations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Программа лояльности'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Карточка с текущим количеством баллов
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.stars,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ваши баллы',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$currentPoints',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Справка по программе лояльности
            Text(
              'О программе',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      context,
                      Icons.add_circle,
                      'Начисление баллов',
                      'За каждое бронирование вы получаете баллы. 1 балл = 1% от стоимости бронирования.',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      Icons.shopping_cart,
                      'Использование баллов',
                      'Баллы можно использовать для получения скидки на следующее бронирование. 100 баллов = 1% скидки.',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      Icons.history,
                      'История операций',
                      'Все операции с баллами сохраняются в истории. Вы можете отслеживать все начисления и траты.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // История операций
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'История операций',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (operations.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      _showFilterDialog(context, ref);
                    },
                    child: const Text('Фильтр'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (operations.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'История операций пуста',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Баллы будут начисляться при создании бронирований',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...operations.map((operation) => _buildOperationCard(context, operation)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOperationCard(BuildContext context, LoyaltyOperation operation) {
    final isEarned = operation.type == LoyaltyOperationType.earned;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isEarned
              ? Colors.green.shade100
              : Colors.orange.shade100,
          child: Icon(
            isEarned ? Icons.add : Icons.remove,
            color: isEarned ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(
          operation.description,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          _formatDate(operation.date),
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Text(
          '${isEarned ? '+' : '-'}${operation.points}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isEarned ? Colors.green : Colors.orange,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Фильтр операций'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Все операции'),
              leading: const Icon(Icons.all_inclusive),
              onTap: () {
                Navigator.pop(context);
                // Можно добавить фильтрацию в провайдер
              },
            ),
            ListTile(
              title: const Text('Только начисления'),
              leading: const Icon(Icons.add_circle, color: Colors.green),
              onTap: () {
                Navigator.pop(context);
                // Можно добавить фильтрацию в провайдер
              },
            ),
            ListTile(
              title: const Text('Только траты'),
              leading: const Icon(Icons.remove_circle, color: Colors.orange),
              onTap: () {
                Navigator.pop(context);
                // Можно добавить фильтрацию в провайдер
              },
            ),
          ],
        ),
      ),
    );
  }
}



