import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/collection_type.dart';
import '../../viewmodels/collections/meal_collection_view_model.dart';
import '../../widgets/collection_nav_actions.dart';
import '../../widgets/image_size_selector.dart';
import '../../widgets/meals_grid.dart';
import '../../widgets/meal_search_bar.dart';
import '../meals/meal_detail_screen.dart';

class MealCollectionScreen<T extends MealCollectionViewModel>
    extends StatefulWidget {
  final String title;
  final String searchHint;
  final IconData emptyIcon;
  final String emptyMessage;
  final CollectionType? collectionType;

  const MealCollectionScreen({
    super.key,
    required this.title,
    required this.searchHint,
    required this.emptyIcon,
    required this.emptyMessage,
    this.collectionType,
  });

  @override
  State<MealCollectionScreen<T>> createState() =>
      _MealCollectionScreenState<T>();
}

class _MealCollectionScreenState<T extends MealCollectionViewModel>
    extends State<MealCollectionScreen<T>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<T>().loadMeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<T>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [CollectionNavActions(currentType: widget.collectionType)],
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Carregando pratos',
              ),
            );
          }

          if (viewModel.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      widget.emptyIcon,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      widget.emptyMessage,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              MealSearchBar(
                hintText: widget.searchHint,
                onSubmitted: (query) {
                  context.read<T>().setSearchQuery(query);
                },
                onClear: () {
                  context.read<T>().setSearchQuery('');
                },
              ),
              ImageSizeSelector(
                selectedSize: viewModel.selectedSize,
                onSelected: (size) {
                  context.read<T>().setSelectedSize(size);
                },
              ),
              Expanded(
                child: viewModel.displayedMeals.isEmpty
                    ? Center(
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            'Nenhum prato encontrado para "${viewModel.searchQuery}".',
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : MealsGrid(
                        meals: viewModel.displayedMeals,
                        size: viewModel.selectedSize,
                        onMealTap: (meal) async {
                          await MealDetailScreen.navigate(context, meal);
                          if (context.mounted) {
                            context.read<T>().loadMeals();
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
