import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/meal_repository.dart';
import 'repositories/meal_repository_impl.dart';
import 'screens/meals_screen.dart';
import 'viewmodels/meals_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<MealRepository>(create: (_) => MealRepositoryImpl()),
        ChangeNotifierProvider<MealsViewModel>(
          create: (context) => MealsViewModel(context.read<MealRepository>()),
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
