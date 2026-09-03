import 'package:flutter/material.dart';

import 'services/meal_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final mealService = MealService();

  try {
    final meals = await mealService.searchMeals('chicken');

    for (final meal in meals) {
      debugPrint('Nome: ${meal.name}');
      debugPrint('ID: ${meal.id}');
      debugPrint('Imagem: ${meal.image}');
      debugPrint('------------------');
    }
  } catch (e) {
    debugPrint('Erro: $e');
  }

  runApp(const DishlyApp());
}

class DishlyApp extends StatelessWidget {
  const DishlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'Dishly',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ); 
  }
}