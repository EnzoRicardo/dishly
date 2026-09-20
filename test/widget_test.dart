// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:dishly/main.dart';
import 'package:dishly/models/meal.dart';
import 'package:dishly/repositories/auth/auth_repository.dart';
import 'package:dishly/repositories/collections/cooked_meals_repository.dart';
import 'package:dishly/repositories/collections/favorites_repository.dart';
import 'package:dishly/repositories/meals/meal_repository.dart';
import 'package:dishly/viewmodels/auth/auth_view_model.dart';
import 'package:dishly/viewmodels/collections/cooked_meals_view_model.dart';
import 'package:dishly/viewmodels/collections/favorites_view_model.dart';
import 'package:dishly/viewmodels/meals/meals_view_model.dart';

class FakeMealRepository implements MealRepository {
  @override
  Future<List<Meal>> searchMeals([String query = '']) async => [];

  @override
  Future<Meal?> getMealById(String id) async => null;
}

class FakeAuthRepository implements AuthRepository {
  String? _currentUser = 'test_user';

  @override
  Future<String?> getUser() async => _currentUser;

  @override
  Future<void> saveUser(String username) async {
    _currentUser = username;
  }

  @override
  Future<void> clearUser() async {
    _currentUser = null;
  }

  @override
  Future<bool> authenticate(String username, String password) async {
    _currentUser = username;
    return true;
  }
}

class FakeMealCollectionRepository
    implements FavoritesRepository, CookedMealsRepository {
  final List<Meal> _meals = [];

  @override
  Future<bool> contains(String id) async => _meals.any((m) => m.id == id);

  @override
  Future<List<Meal>> getMeals() async => List.from(_meals);

  @override
  Future<void> toggle(Meal meal) async {
    if (_meals.any((m) => m.id == meal.id)) {
      _meals.removeWhere((m) => m.id == meal.id);
    } else {
      _meals.add(meal);
    }
  }
}

void main() {
  testWidgets('DishlyApp smoke test', (WidgetTester tester) async {
    final fakeMealRepo = FakeMealRepository();
    final fakeAuthRepo = FakeAuthRepository();
    final fakeFavRepo = FakeMealCollectionRepository();
    final fakeCookedRepo = FakeMealCollectionRepository();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<MealRepository>.value(value: fakeMealRepo),
          Provider<AuthRepository>.value(value: fakeAuthRepo),
          Provider<FavoritesRepository>.value(value: fakeFavRepo),
          Provider<CookedMealsRepository>.value(value: fakeCookedRepo),
          ChangeNotifierProvider<AuthViewModel>(
            create: (_) => AuthViewModel(fakeAuthRepo)..loadCurrentUser(),
          ),
          ChangeNotifierProvider<MealsViewModel>(
            create: (_) => MealsViewModel(fakeMealRepo),
          ),
          ChangeNotifierProvider<FavoritesViewModel>(
            create: (_) => FavoritesViewModel(fakeFavRepo),
          ),
          ChangeNotifierProvider<CookedMealsViewModel>(
            create: (_) => CookedMealsViewModel(fakeCookedRepo),
          ),
        ],
        child: const DishlyApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(DishlyApp), findsOneWidget);
  });
}
