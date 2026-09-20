import 'package:dishly/viewmodels/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';

import '../../viewmodels/collections/cooked_meals_view_model.dart';
import '../../viewmodels/collections/favorites_view_model.dart';
import '../../viewmodels/collections/meal_collection_view_model.dart';
import '../../viewmodels/meals/meals_view_model.dart';
import '../../widgets/collection_nav_actions.dart';
import '../../widgets/image_size_selector.dart';
import '../../widgets/meals_grid.dart';
import '../../widgets/meal_search_bar.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<MealCollectionViewModel> _collections(BuildContext context) => [
        context.read<FavoritesViewModel>(),
        context.read<CookedMealsViewModel>(),
      ];

  Future<void> _handleSearch(String query) async {
    final mealsVm = context.read<MealsViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final meals = await mealsVm.fetchMeals(query);
    if (!mounted) return;
    if (query.trim().isNotEmpty && meals.length == 1) {
      await MealDetailScreen.navigate(context, meals.first);
    } else if (query.trim().isNotEmpty && meals.isEmpty) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Nenhum prato encontrado para "$query".'),
        ),
      );
    }
  }

  Future<void> _handleLogout() async {
    for (final collection in _collections(context)) {
      collection.clear();
    }
    await context.read<AuthViewModel>().logout();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealsViewModel>().fetchMeals();
      for (final collection in _collections(context)) {
        collection.loadMeals();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MealsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          const CollectionNavActions(),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: 'Sair',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Column(
        children: [
          MealSearchBar(
            onSubmitted: _handleSearch,
            onClear: () => context.read<MealsViewModel>().fetchMeals(),
          ),
          ImageSizeSelector(
            selectedSize: viewModel.selectedSize,
            onSelected: (size) {
              context.read<MealsViewModel>().setSelectedSize(size);
            },
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (viewModel.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      semanticsLabel: 'Carregando pratos',
                    ),
                  );
                }

                if (viewModel.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Semantics(
                          liveRegion: true,
                          child: Text(viewModel.errorMessage!),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<MealsViewModel>().fetchMeals(),
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }

                if (viewModel.displayedMeals.isEmpty) {
                  return Center(
                    child: Semantics(
                      liveRegion: true,
                      child: const Text('Nenhum prato encontrado.'),
                    ),
                  );
                }

                return MealsGrid(
                  meals: viewModel.displayedMeals,
                  size: viewModel.selectedSize,
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 88.0),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: viewModel.hasMore && !viewModel.isLoading
          ? ElevatedButton(
              onPressed: viewModel.isLoadingMore
                  ? null
                  : () => context.read<MealsViewModel>().loadMore(),
              style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: viewModel.isLoadingMore
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                        semanticsLabel: 'Carregando mais pratos',
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Carregar Mais (${viewModel.remainingCount} restantes)',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
            )
          : null,
    );
  }
}
