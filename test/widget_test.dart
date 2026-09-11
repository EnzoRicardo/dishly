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
import 'package:dishly/repositories/meal_repository.dart';
import 'package:dishly/viewmodels/meals_view_model.dart';

class FakeMealRepository implements MealRepository {
  @override
  Future<List<Meal>> searchMeals([String query = '']) async => [];

  @override
  Future<Meal?> getMealById(String id) async => null;

  @override
  Future<Meal?> getRandomMeal() async => null;

  @override
  Future<List<String>> getCategories() async => [];

  @override
  Future<List<Meal>> getMealsByCategory(String category) async => [];

  @override
  List<String> getImages(List<Meal> meals,
          [ImageSize size = ImageSize.defaultSize]) =>
      [];
}

void main() {
  testWidgets('DishlyApp smoke test', (WidgetTester tester) async {
    final fakeRepo = FakeMealRepository();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<MealRepository>.value(value: fakeRepo),
          ChangeNotifierProvider<MealsViewModel>(
            create: (_) => MealsViewModel(fakeRepo),
          ),
        ],
        child: const DishlyApp(),
      ),
    );

    expect(find.byType(DishlyApp), findsOneWidget);
  });
}
