import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dishly/constants/storage_keys.dart';
import 'package:dishly/models/meal.dart';
import 'package:dishly/repositories/auth/auth_repository_impl.dart';
import 'package:dishly/repositories/collections/cooked_meals_repository.dart';
import 'package:dishly/repositories/collections/favorites_repository.dart';
import 'package:dishly/repositories/meals/meal_repository.dart';
import 'package:dishly/screens/collections/favorites_screen.dart';
import 'package:dishly/screens/meals/meal_detail_screen.dart';
import 'package:dishly/viewmodels/auth/auth_view_model.dart';
import 'package:dishly/viewmodels/collections/cooked_meals_view_model.dart';
import 'package:dishly/viewmodels/collections/favorites_view_model.dart';
import 'package:dishly/viewmodels/meals/meals_view_model.dart';

class MockMealRepository implements MealRepository {
  List<Meal> mealsToReturn = [];

  @override
  Future<List<Meal>> searchMeals([String query = '']) async => mealsToReturn;

  @override
  Future<Meal?> getMealById(String id) async {
    return mealsToReturn.firstWhere(
      (m) => m.id == id,
      orElse: () => Meal(id: id, name: 'Default', image: ''),
    );
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
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthRepositoryImpl & User Data Isolation', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('registers user on first login and validates password on subsequent login', () async {
      final authRepo = AuthRepositoryImpl();

      // First login creates the user
      final success1 = await authRepo.authenticate('alice', 'password123');
      expect(success1, isTrue);
      expect(await authRepo.getUser(), 'alice');

      // Subsequent login with correct password succeeds
      final success2 = await authRepo.authenticate('alice', 'password123');
      expect(success2, isTrue);

      // Login with incorrect password fails
      final fail = await authRepo.authenticate('alice', 'wrongpass');
      expect(fail, isFalse);

      // Logout clears session
      await authRepo.clearUser();
      expect(await authRepo.getUser(), isNull);
    });

    test('scopes collection keys to active user', () {
      final aliceFavKey = StorageKeys.userCollectionKey('alice', StorageKeys.favorites);
      final bobFavKey = StorageKeys.userCollectionKey('bob', StorageKeys.favorites);
      final noUserKey = StorageKeys.userCollectionKey(null, StorageKeys.favorites);

      expect(aliceFavKey, 'alice_favorite_meals');
      expect(bobFavKey, 'bob_favorite_meals');
      expect(noUserKey, 'favorite_meals');
      expect(aliceFavKey, isNot(equals(bobFavKey)));
    });
  });

  group('MealsViewModel Search & Pagination', () {
    test('fetchMeals returns list of meals for navigation decision', () async {
      final repo = MockMealRepository();
      repo.mealsToReturn = [
        Meal(id: '1', name: 'Arrabiata', image: 'https://example.com/arrabiata.jpg'),
      ];

      final vm = MealsViewModel(repo);
      final results = await vm.fetchMeals('Arrabiata');

      expect(results.length, 1);
      expect(results.first.name, 'Arrabiata');
      expect(vm.displayedMeals.length, 1);
    });

    test('loadMore increments visible meals synchronously', () async {
      final repo = MockMealRepository();
      repo.mealsToReturn = List.generate(
        10,
        (i) => Meal(id: '$i', name: 'Meal $i', image: ''),
      );

      final vm = MealsViewModel(repo);
      await vm.fetchMeals();

      expect(vm.displayedMeals.length, 6);
      expect(vm.hasMore, isTrue);

      vm.loadMore();

      expect(vm.displayedMeals.length, 10);
      expect(vm.hasMore, isFalse);
    });
  });

  group('FavoritesViewModel Global State', () {
    test('toggle updates state in-memory and notifies listeners', () async {
      final repo = FakeMealCollectionRepository();
      final vm = FavoritesViewModel(repo);
      final meal = Meal(id: '42', name: 'Pizza', image: '');

      expect(vm.contains('42'), isFalse);

      await vm.toggle(meal);
      expect(vm.contains('42'), isTrue);
      expect(vm.meals.length, 1);

      await vm.toggle(meal);
      expect(vm.contains('42'), isFalse);
      expect(vm.meals.isEmpty, isTrue);
    });

    test('clear resets in-memory collection and search query on logout', () async {
      final repo = FakeMealCollectionRepository();
      final vm = FavoritesViewModel(repo);
      final meal = Meal(id: '99', name: 'Burger', image: '');

      await vm.toggle(meal);
      vm.setSearchQuery('bur');
      expect(vm.meals.length, 1);
      expect(vm.searchQuery, 'bur');

      vm.clear();

      expect(vm.meals.isEmpty, isTrue);
      expect(vm.searchQuery.isEmpty, isTrue);
    });

    test('setSearchQuery filters meals and returns displayed results for navigation', () async {
      final repo = FakeMealCollectionRepository();
      final vm = FavoritesViewModel(repo);
      await vm.toggle(Meal(id: '1', name: 'Arrabiata', image: ''));
      await vm.toggle(Meal(id: '2', name: 'Carbonara', image: ''));

      final singleResult = vm.setSearchQuery('Arra');
      expect(singleResult.length, 1);
      expect(singleResult.first.name, 'Arrabiata');

      final emptyResult = vm.setSearchQuery('Pizza');
      expect(emptyResult.isEmpty, isTrue);

      final allResults = vm.setSearchQuery('');
      expect(allResults.length, 2);
    });
  });

  group('AuthViewModel State Management', () {
    test('logout clears current user and error messages', () async {
      final authRepo = AuthRepositoryImpl();
      final authVm = AuthViewModel(authRepo);

      // Attempt empty login to generate validation error
      await authVm.login('', '');
      expect(authVm.usernameErrorMessage, isNotNull);
      expect(authVm.passwordErrorMessage, isNotNull);

      await authVm.logout();

      expect(authVm.currentUser, isNull);
      expect(authVm.usernameErrorMessage, isNull);
      expect(authVm.passwordErrorMessage, isNull);
      expect(authVm.errorMessage, isNull);
    });
  });

  group('MealCollectionScreen Auto-Navigation on Search', () {
    testWidgets(
        'navigates directly to MealDetailScreen on single search match in collection',
        (tester) async {
      final mockMealRepo = MockMealRepository();
      final fakeFavRepo = FakeMealCollectionRepository();
      final favMeal =
          Meal(id: '1', name: 'Arrabiata', image: 'https://example.com/1.jpg');
      final otherMeal =
          Meal(id: '2', name: 'Carbonara', image: 'https://example.com/2.jpg');
      await fakeFavRepo.toggle(favMeal);
      await fakeFavRepo.toggle(otherMeal);

      final favVm = FavoritesViewModel(fakeFavRepo);
      final cookedVm = CookedMealsViewModel(FakeMealCollectionRepository());

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<MealRepository>.value(value: mockMealRepo),
            Provider<FavoritesRepository>.value(value: fakeFavRepo),
            Provider<CookedMealsRepository>.value(
              value: FakeMealCollectionRepository(),
            ),
            ChangeNotifierProvider<FavoritesViewModel>.value(value: favVm),
            ChangeNotifierProvider<CookedMealsViewModel>.value(value: cookedVm),
          ],
          child: const MaterialApp(
            home: FavoritesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Arrabiata'), findsOneWidget);
      expect(find.text('Carbonara'), findsOneWidget);

      // Enter search query that matches exactly one meal and submit
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Arrabiata');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Automatically navigated to MealDetailScreen
      expect(find.byType(MealDetailScreen), findsOneWidget);
    });
  });
}
