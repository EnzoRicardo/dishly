import 'package:flutter/material.dart';

import 'models/meal.dart';
import 'services/meal_service.dart';

void main() {
  runApp(const DishlyApp());
}

class DishlyApp extends StatelessWidget {
  const DishlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dishly',
      debugShowCheckedModeBanner: false,
      home: const MealsScreen(),
    );
  }
}

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final MealService _mealService = MealService();
  final TextEditingController _searchController = TextEditingController();
  ImageSize _selectedSize = ImageSize.defaultSize;

  static const int _pageSize = 6;
  int _visibleCount = _pageSize;

  bool _isLoading = false;
  String? _errorMessage;
  List<Meal> _allMeals = [];

  bool get _hasMore => _visibleCount < _allMeals.length;

  @override
  void initState() {
    super.initState();
    _fetchMeals();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchMeals([String? query]) async {
    final term = (query ?? _searchController.text).trim();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _visibleCount = _pageSize;
    });

    try {
      final meals = await _mealService.searchMeals(term);
      setState(() {
        _allMeals = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Não foi possível carregar os pratos.';
        _isLoading = false;
      });
    }
  }

  void _loadMore() {
    setState(() {
      _visibleCount += _pageSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pratos da API'),
        centerTitle: true,
        actions: [
          PopupMenuButton<ImageSize>(
            icon: const Icon(Icons.photo_size_select_actual_outlined),
            tooltip: 'Tamanho da Imagem',
            initialValue: _selectedSize,
            onSelected: (size) {
              setState(() {
                _selectedSize = size;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ImageSize.small,
                child: Text('Pequeno (150px)'),
              ),
              const PopupMenuItem(
                value: ImageSize.medium,
                child: Text('Médio (350px)'),
              ),
              const PopupMenuItem(
                value: ImageSize.large,
                child: Text('Grande (500px)'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar prato...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _fetchMeals();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (value) => _fetchMeals(value),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (_isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_errorMessage != null) {
                  return Center(child: Text(_errorMessage!));
                }

                if (_allMeals.isEmpty) {
                  return const Center(child: Text('Nenhum prato encontrado.'));
                }

                final displayedMeals = _allMeals.take(_visibleCount).toList();

                return Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: _selectedSize.maxExtent,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: displayedMeals.length,
                    itemBuilder: (context, index) {
                      final meal = displayedMeals[index];
                      return Card(
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.network(
                                meal.getImage(_selectedSize),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.broken_image),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                meal.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
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
      floatingActionButton: _hasMore && !_isLoading
          ? FloatingActionButton.extended(
              onPressed: _loadMore,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: Text(
                'Carregar Mais (${_allMeals.length - _visibleCount} restantes)',
              ),
            )
          : null,
    );
  }
}
