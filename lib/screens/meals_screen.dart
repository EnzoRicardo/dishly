import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../viewmodels/meals_view_model.dart';
import '../widgets/meal_card.dart';
import '../widgets/meal_search_bar.dart';

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
          PopupMenuButton<ImageSize>(
            icon: const Icon(Icons.photo_size_select_actual_outlined),
            tooltip: 'Tamanho da Imagem',
            initialValue: viewModel.selectedSize,
            onSelected: (size) {
              context.read<MealsViewModel>().setSelectedSize(size);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: ImageSize.small,
                child: Text('Pequeno (150px)'),
              ),
              PopupMenuItem(
                value: ImageSize.medium,
                child: Text('Médio (350px)'),
              ),
              PopupMenuItem(
                value: ImageSize.large,
                child: Text('Grande (500px)'),
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

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: viewModel.selectedSize.maxExtent,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: viewModel.displayedMeals.length,
                    itemBuilder: (context, index) {
                      return MealCard(
                        meal: viewModel.displayedMeals[index],
                        size: viewModel.selectedSize,
                      );
                    },
                  ),
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
