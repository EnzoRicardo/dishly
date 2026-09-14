import 'package:flutter/material.dart';

import '../../models/collection_type.dart';
import '../../viewmodels/collections/cooked_meals_view_model.dart';
import 'meal_collection_screen.dart';

class CookedMealsScreen extends StatelessWidget {
  const CookedMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MealCollectionScreen<CookedMealsViewModel>(
      title: 'Pratos Cozinhados',
      searchHint: 'Buscar nos cozinhados...',
      emptyIcon: Icons.restaurant_outlined,
      emptyMessage: 'Nenhum prato cozinhado ainda.',
      collectionType: CollectionType.cooked,
    );
  }
}
