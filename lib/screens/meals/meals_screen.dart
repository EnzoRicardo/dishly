import 'package:dishly/viewmodels/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/meal.dart';
import '../../viewmodels/meals/meals_view_model.dart';
import '../../widgets/collection_nav_actions.dart';
import '../../widgets/meals_grid.dart';
import '../../widgets/meal_search_bar.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealsViewModel>().fetchMeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MealsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dishly',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          const CollectionNavActions(),
          PopupMenuButton<void>(
            tooltip: 'Mais opções',
            iconColor: Theme.of(context).colorScheme.primary,
            itemBuilder: (context) => [
              CheckedPopupMenuItem<void>(
                checked: viewModel.selectedSize == ImageSize.small,
                onTap: () => context.read<MealsViewModel>().setSelectedSize(
                  ImageSize.small,
                ),
                child: const Text('Pequeno (150px)'),
              ),
              CheckedPopupMenuItem<void>(
                checked: viewModel.selectedSize == ImageSize.medium,
                onTap: () => context.read<MealsViewModel>().setSelectedSize(
                  ImageSize.medium,
                ),
                child: const Text('Médio (350px)'),
              ),
              CheckedPopupMenuItem<void>(
                checked: viewModel.selectedSize == ImageSize.large,
                onTap: () => context.read<MealsViewModel>().setSelectedSize(
                  ImageSize.large,
                ),
                child: const Text('Grande (500px)'),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<void>(
                onTap: () => context.read<AuthViewModel>().logout(),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 12),
                    Text('Sair'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          MealSearchBar(
            onSubmitted: (query) {
              context.read<MealsViewModel>().fetchMeals(query);
            },
            onClear: () {
              context.read<MealsViewModel>().fetchMeals();
            },
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.errorMessage != null) {
                  return Center(child: Text(viewModel.errorMessage!));
                }

                if (viewModel.displayedMeals.isEmpty) {
                  return const Center(child: Text('Nenhum prato encontrado.'));
                }

                return MealsGrid(
                  meals: viewModel.displayedMeals,
                  size: viewModel.selectedSize,
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: viewModel.hasMore && !viewModel.isLoading
          ? FloatingActionButton.extended(
              onPressed: () {
                context.read<MealsViewModel>().loadMore();
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              icon: const Icon(Icons.add),
              label: Text(
                'Carregar Mais (${viewModel.remainingCount} restantes)',
              ),
            )
          : null,
    );
  }
}
