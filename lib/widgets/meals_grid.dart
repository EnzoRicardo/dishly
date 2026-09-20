import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/collection_type.dart';
import '../models/meal.dart';
import '../screens/meals/meal_detail_screen.dart';
import '../viewmodels/collections/cooked_meals_view_model.dart';
import '../viewmodels/collections/favorites_view_model.dart';
import 'meal_card.dart';

class MealsGrid extends StatelessWidget {
  final List<Meal> meals;
  final ImageSize size;
  final EdgeInsetsGeometry padding;
  final ValueChanged<Meal>? onMealTap;

  const MealsGrid({
    super.key,
    required this.meals,
    required this.size,
    this.padding = const EdgeInsets.all(16.0),
    this.onMealTap,
  });

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesViewModel>();
    final cooked = context.watch<CookedMealsViewModel>();
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);
    final adjustedAspectRatio = (0.78 / textScale).clamp(0.55, 0.85);

    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: size.maxExtent,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: adjustedAspectRatio,
      ),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];

        final isFavorite = favorites.contains(meal.id);
        final isCooked = cooked.contains(meal.id);

        return MergeSemantics(
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            borderRadius: BorderRadius.circular(12),
            onTap: onMealTap != null
                ? () => onMealTap!(meal)
                : () => MealDetailScreen.navigate(context, meal),
            child: MealCard(
              meal: meal,
              size: size,
              indicators: [
                if (isCooked)
                  Icon(
                    CollectionType.cooked.selectedIcon,
                    size: 18,
                    color: CollectionType.cooked.activeColor,
                    semanticLabel: CollectionType.cooked.title,
                  ),
                if (isFavorite)
                  Icon(
                    CollectionType.favorites.selectedIcon,
                    size: 20,
                    color: CollectionType.favorites.activeColor,
                    semanticLabel: CollectionType.favorites.title,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
