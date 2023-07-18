class CategoriesDto{
  final String name;

  CategoriesDto({
    required this.name,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
  };



}