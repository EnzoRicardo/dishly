import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/favorites_view_model.dart';
import '../widgets/image_size_selector.dart';
import '../widgets/meals_grid.dart';
import '../widgets/meal_search_bar.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesViewModel>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FavoritesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
        centerTitle: true,
        actions: [
          ImageSizeSelector(
            selectedSize: viewModel.selectedSize,
            onSelected: (size) {
              context.read<FavoritesViewModel>().setSelectedSize(size);
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum prato favorito ainda.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              MealSearchBar(
                hintText: 'Buscar nos favoritos...',
                onSubmitted: (query) {
                  context.read<FavoritesViewModel>().setSearchQuery(query);
                },
                onClear: () {
                  context.read<FavoritesViewModel>().setSearchQuery('');
                },
              ),
              Expanded(
                child: viewModel.displayedFavorites.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhum favorito encontrado para "${viewModel.searchQuery}".',
                          style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                        ),
                      )
                    : MealsGrid(
                        meals: viewModel.displayedFavorites,
                        size: viewModel.selectedSize,
                        onMealTap: (meal) async {
                          await MealDetailScreen.navigate(context, meal);
                          if (context.mounted) {
                            context.read<FavoritesViewModel>().loadFavorites();
                          }
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
