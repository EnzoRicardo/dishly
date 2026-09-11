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

  String getImage([ImageSize size = ImageSize.defaultSize]) {
    if (image.isEmpty) return image;
    return '$image/${size.name}';
  }
}

enum ImageSize {
  small(150),
  medium(350),
  large(500);

  final double maxExtent;
  const ImageSize(this.maxExtent);

  static const ImageSize defaultSize = ImageSize.small;
}
