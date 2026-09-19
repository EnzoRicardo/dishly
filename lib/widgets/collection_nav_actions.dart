import 'package:flutter/material.dart';

import '../models/collection_type.dart';
import '../screens/collections/cooked_meals_screen.dart';
import '../screens/collections/favorites_screen.dart';

class CollectionNavActions extends StatelessWidget {
  final CollectionType? currentType;

  const CollectionNavActions({super.key, this.currentType});

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
        if (currentType != CollectionType.cooked)
          IconButton(
            icon: Icon(
              Icons.restaurant_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            tooltip: 'Pratos Cozinhados',
            onPressed: () => _navigate(context, const CookedMealsScreen()),
          ),
        if (currentType != CollectionType.favorites)
          IconButton(
            icon: Icon(
              Icons.favorite_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            tooltip: 'Meus Favoritos',
            onPressed: () => _navigate(context, const FavoritesScreen()),
          ),
      ],
    );
  }
}
