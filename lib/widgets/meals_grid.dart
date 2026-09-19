import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../screens/meals/meal_detail_screen.dart';
import '../viewmodels/collections/favorites_view_model.dart';
import 'meal_card.dart';

class MealsGrid extends StatelessWidget {
  final List<Meal> meals;
  final ImageSize size;
  final EdgeInsetsGeometry padding;
  final Future<void> Function(Meal meal)? onMealTap;

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

    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: size.maxExtent,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: meals.length,
      itemBuilder: (context, index) {
        final meal = meals[index];

        return MergeSemantics(
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              if (onMealTap != null) {
                await onMealTap!(meal);
              } else {
                await MealDetailScreen.navigate(context, meal);
              }
              if (context.mounted) {
                await context.read<FavoritesViewModel>().loadMeals();
              }
            },
            child: MealCard(
              meal: meal,
              size: size,
              isFavorite: favorites.contains(meal.id),
            ),
          ),
        );
      },
    );
  }
}
