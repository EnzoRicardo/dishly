import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/meals/meals_view_model.dart';
import '../../widgets/collection_nav_actions.dart';
import '../../widgets/image_size_selector.dart';
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
        title: const Text('Pratos da API'),
        centerTitle: true,
        actions: [
          const CollectionNavActions(),
          ImageSizeSelector(
            selectedSize: viewModel.selectedSize,
            onSelected: (size) {
              context.read<MealsViewModel>().setSelectedSize(size);
            },
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
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: Text(
                'Carregar Mais (${viewModel.remainingCount} restantes)',
              ),
            )
          : null,
    );
  }
}
