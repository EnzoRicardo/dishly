class Meal {
  final String id;
  final String name;
  final String image;
  final String? category;
  final String? area;
  final String? instructions;

  Meal({
    required this.id,
    required this.name,
    required this.image,
    this.category,
    this.area,
    this.instructions,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      image: json['strMealThumb'] ?? '',
      category: json['strCategory'],
      area: json['strArea'],
      instructions: json['strInstructions'],
    );
  }
}