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
  small(150),
  medium(350),
  large(500);

  final double maxExtent;
  const ImageSize(this.maxExtent);

  static const ImageSize defaultSize = ImageSize.small;
}
