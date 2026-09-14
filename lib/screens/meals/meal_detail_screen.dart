import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/collection_type.dart';
import '../../models/meal.dart';
import '../../repositories/collections/cooked_meals_repository.dart';
import '../../repositories/collections/favorites_repository.dart';
import '../../repositories/meals/meal_repository.dart';
import '../../viewmodels/meals/meal_detail_view_model.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final String mealName;

  const MealDetailScreen({
    super.key,
    required this.mealId,
    required this.mealName,
  });

  static Future<void> navigate(BuildContext context, Meal meal) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (ctx) => MealDetailViewModel(
            ctx.read<MealRepository>(),
            {
              CollectionType.favorites: ctx.read<FavoritesRepository>(),
              CollectionType.cooked: ctx.read<CookedMealsRepository>(),
            },
          ),
          child: MealDetailScreen(
            mealId: meal.id,
            mealName: meal.name,
          ),
        ),
      ),
    );
  }

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealDetailViewModel>().loadMealById(widget.mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MealDetailViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mealName),
        actions: CollectionType.values.map((type) {
          final isSelected = viewModel.isInCollection(type);
          return IconButton(
            isSelected: isSelected,
            icon: Icon(type.icon),
            selectedIcon: Icon(type.selectedIcon, color: type.activeColor),
            tooltip: isSelected ? type.activeTooltip : type.inactiveTooltip,
            onPressed: viewModel.meal != null
                ? () => context
                    .read<MealDetailViewModel>()
                    .toggleCollection(type)
                : null,
          );
        }).toList(),
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(viewModel.errorMessage!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => viewModel.loadMealById(widget.mealId),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final meal = viewModel.meal;
          if (meal == null) {
            return const Center(child: Text('Prato não encontrado.'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Large Image Header
                Image.network(
                  meal.getImage(ImageSize.large),
                  height: 260,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 200,
                    child: Icon(Icons.broken_image, size: 64),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Title & Badges
                      Text(
                        meal.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (meal.category != null)
                            Chip(
                              avatar: const Icon(
                                Icons.category_outlined,
                                size: 16,
                              ),
                              label: Text(meal.category!),
                            ),
                          if (meal.area != null)
                            Chip(
                              avatar: const Icon(Icons.public, size: 16),
                              label: Text(meal.area!),
                            ),
                        ],
                      ),
                      const Divider(height: 32),

                      // 3. Ingredients (Using our Record / List)
                      if (meal.ingredients.isNotEmpty) ...[
                        Text(
                          'Ingredientes',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 0,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.4),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: meal.ingredients.map((ingredient) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: Colors.deepOrange,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          ingredient.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ingredient.measure,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const Divider(height: 32),
                      ],

                      // 4. Instructions
                      if (meal.instructions != null &&
                          meal.instructions!.isNotEmpty) ...[
                        Text(
                          'Modo de Preparo',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meal.instructions!,
                          style: const TextStyle(fontSize: 15, height: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
