import 'package:flutter/material.dart';

import '../../models/collection_type.dart';
import '../../viewmodels/collections/favorites_view_model.dart';
import 'meal_collection_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MealCollectionScreen<FavoritesViewModel>(
      collectionType: CollectionType.favorites,
    );
  }
}
