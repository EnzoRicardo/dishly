import 'package:flutter/material.dart';

import '../models/collection_type.dart';
import '../screens/collections/cooked_meals_screen.dart';
import '../screens/collections/favorites_screen.dart';

class CollectionNavActions extends StatelessWidget {
  final CollectionType? currentType;

  const CollectionNavActions({super.key, this.currentType});

  Widget _screenFor(CollectionType type) => switch (type) {
        CollectionType.cooked => const CookedMealsScreen(),
        CollectionType.favorites => const FavoritesScreen(),
      };

  void _navigate(BuildContext context, Widget screen) {
    if (currentType != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final type in CollectionType.values)
          if (type != currentType)
            IconButton(
              icon: Icon(
                type.icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              tooltip: type.title,
              onPressed: () => _navigate(context, _screenFor(type)),
            ),
      ],
    );
  }
}
