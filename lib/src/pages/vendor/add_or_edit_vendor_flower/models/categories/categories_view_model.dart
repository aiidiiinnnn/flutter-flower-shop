class CategoriesViewModel{
  final int id;
  final String name;

  CategoriesViewModel({
    required this.id,
    required this.name,
  });

  factory CategoriesViewModel.fromJson(Map<String,dynamic> json){
    return CategoriesViewModel(
        id: json["id"],
        name: json["name"],
    );
  }

  CategoriesViewModel copyWith({
    int? id,
    String? name,
  })
  => CategoriesViewModel(
    id: id ?? this.id,
    name: name ?? this.name,
  );

}