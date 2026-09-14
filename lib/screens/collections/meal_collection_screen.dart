import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/collection_type.dart';
import '../../viewmodels/collections/meal_collection_view_model.dart';
import '../../widgets/collection_nav_actions.dart';
import '../../widgets/image_size_selector.dart';
import '../../widgets/meals_grid.dart';
import '../../widgets/meal_search_bar.dart';
import '../meals/meal_detail_screen.dart';

class MealCollectionScreen<T extends MealCollectionViewModel> extends StatefulWidget {
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
  State<MealCollectionScreen<T>> createState() => _MealCollectionScreenState<T>();
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
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          CollectionNavActions(currentType: widget.collectionType),
          ImageSizeSelector(
            selectedSize: viewModel.selectedSize,
            onSelected: (size) {
              context.read<T>().setSelectedSize(size);
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
                    widget.emptyIcon,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.emptyMessage,
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
                hintText: widget.searchHint,
                onSubmitted: (query) {
                  context.read<T>().setSearchQuery(query);
                },
                onClear: () {
                  context.read<T>().setSearchQuery('');
                },
              ),
              Expanded(
                child: viewModel.displayedMeals.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhum prato encontrado para "${viewModel.searchQuery}".',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
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

