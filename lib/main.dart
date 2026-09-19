import 'package:dishly/viewmodels/auth/auth_view_model.dart';

import 'repositories/auth/auth_repository.dart';
import 'repositories/auth/auth_repository_impl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repositories/collections/cooked_meals_repository.dart';
import 'repositories/collections/cooked_meals_repository_impl.dart';
import 'repositories/collections/favorites_repository.dart';
import 'repositories/collections/favorites_repository_impl.dart';
import 'repositories/meals/meal_repository.dart';
import 'repositories/meals/meal_repository_impl.dart';
import 'screens/auth/auth_gate.dart';
import 'viewmodels/collections/cooked_meals_view_model.dart';
import 'viewmodels/collections/favorites_view_model.dart';
import 'viewmodels/meals/meals_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
        Provider<MealRepository>(create: (_) => MealRepositoryImpl()),
        Provider<FavoritesRepository>(create: (_) => FavoritesRepositoryImpl()),
        Provider<CookedMealsRepository>(
          create: (_) => CookedMealsRepositoryImpl(),
        ),

        ChangeNotifierProvider<AuthViewModel>(
          create: (context) =>
              AuthViewModel(context.read<AuthRepository>())..loadCurrentUser(),
        ),
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
      child: DishlyApp(),
    ),
  );
}

class DishlyApp extends StatelessWidget {
  DishlyApp({super.key});

  final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepOrange);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dishly',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        excludeFromSemantics: true,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: child,
      ),
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        fontFamily: 'Raleway',

        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: colorScheme.surface,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: false,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
          ),
          labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        ),

        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}
