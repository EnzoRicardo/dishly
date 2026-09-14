import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/collections/cooked_meals_repository.dart';
import 'repositories/collections/cooked_meals_repository_impl.dart';
import 'repositories/collections/favorites_repository.dart';
import 'repositories/collections/favorites_repository_impl.dart';
import 'repositories/meals/meal_repository.dart';
import 'repositories/meals/meal_repository_impl.dart';
import 'screens/meals/meals_screen.dart';
import 'viewmodels/collections/cooked_meals_view_model.dart';
import 'viewmodels/collections/favorites_view_model.dart';
import 'viewmodels/meals/meals_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<MealRepository>(create: (_) => MealRepositoryImpl()),
        Provider<FavoritesRepository>(create: (_) => FavoritesRepositoryImpl()),
        Provider<CookedMealsRepository>(
            create: (_) => CookedMealsRepositoryImpl()),
        ChangeNotifierProvider<MealsViewModel>(
          create: (context) => MealsViewModel(context.read<MealRepository>()),
        ),
        ChangeNotifierProvider<FavoritesViewModel>(
          create: (context) =>
              FavoritesViewModel(context.read<FavoritesRepository>()),
        ),
        ChangeNotifierProvider<CookedMealsViewModel>(
          create: (context) =>
              CookedMealsViewModel(context.read<CookedMealsRepository>()),
        ),
      ],
      child: const DishlyApp(),
    ),
  );
}

class DishlyApp extends StatelessWidget {
  const DishlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dishly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MealsScreen(),
    );
  }
}
