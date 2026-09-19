import 'package:flutter/material.dart';

import '../models/collection_type.dart';
import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final ImageSize size;
  final bool isFavorite;

  const MealCard({
    super.key,
    required this.meal,
    required this.size,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  meal.getImage(size),
                  width: double.infinity,
                  excludeFromSemantics: true,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              meal.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600, height: 1.2),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    meal.category ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(
                  isFavorite
                      ? CollectionType.favorites.selectedIcon
                      : CollectionType.favorites.icon,
                  size: 20,
                  color: isFavorite
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  semanticLabel: isFavorite ? 'Favorito' : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
