import 'package:flutter/material.dart';

class Meal {
  final String id;
  final String name;
  final String image;
  final String? category;
  final String? area;
  final String? instructions;
  final String? tags;
  final String? youtubeUrl;
  final String? sourceUrl;
  final List<MealIngredient> ingredients;

  Meal({
    required this.id,
    required this.name,
    required this.image,
    this.category,
    this.area,
    this.instructions,
    this.tags,
    this.youtubeUrl,
    this.sourceUrl,
    this.ingredients = const [],
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final ingredients = <MealIngredient>[];
    for (var i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient is String && ingredient.trim().isNotEmpty) {
        ingredients.add((
          name: ingredient.trim(),
          measure: (measure is String ? measure.trim() : ''),
        ));
      }
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      image: json['strMealThumb'] ?? '',
      category: json['strCategory'],
      area: json['strArea'],
      instructions: json['strInstructions'],
      tags: json['strTags'],
      youtubeUrl: json['strYoutube'],
      sourceUrl: json['strSource'],
      ingredients: ingredients,
    );
  }

  String getImage([ImageSize size = ImageSize.defaultSize]) {
    if (image.isEmpty) return image;
    return '$image/${size.name}';
  }

  Map<String, dynamic> toJson() {
    final mealJson = <String, dynamic>{
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': image,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strTags': tags,
      'strYoutube': youtubeUrl,
      'strSource': sourceUrl,
    };

    for (var i = 0; i < ingredients.length && i < 20; i++) {
      mealJson['strIngredient${i + 1}'] = ingredients[i].name;
      mealJson['strMeasure${i + 1}'] = ingredients[i].measure;
    }

    return mealJson;
  }
}

typedef MealIngredient = ({String name, String measure});

enum ImageSize {
  small(label: 'Pequeno', maxExtent: 150, icon: Icons.view_module),
  medium(label: 'Médio', maxExtent: 240, icon: Icons.grid_view),
  large(label: 'Grande', maxExtent: 500, icon: Icons.view_agenda);

  /// Largura máxima da coluna na grade — não é a resolução da imagem.
  /// A resolução vem do sufixo [name] na URL: `small` serve 150px,
  /// `medium` 350px e `large` 500px.
  final double maxExtent;
  final String label;
  final IconData icon;

  const ImageSize({
    required this.label,
    required this.maxExtent,
    required this.icon,
  });

  static const ImageSize defaultSize = ImageSize.medium;
}
