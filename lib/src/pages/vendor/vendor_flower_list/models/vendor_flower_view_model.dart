
class VendorFlowerViewModel{
  final int id;
  final String name;
  final String imageAddress;
  final String description;
  final int price;
  final List<dynamic> color;
  final List<dynamic> category;
  final int count;

  VendorFlowerViewModel({
    required this.id,
    required this.name,
    required this.imageAddress,
    required this.description,
    required this.price,
    required this.color,
    required this.category,
    required this.count
  });

  factory VendorFlowerViewModel.fromJson(Map<String,dynamic> json){
    return VendorFlowerViewModel(
        id: json["id"],
        name: json["name"],
        imageAddress: json["imageAddress"],
        description:json["description"],
        price: json["price"],
        color: json["color"],
        category: json["category"],
        count: json["count"]
    );
  }

  VendorFlowerViewModel copyWith({
    int? id,
    String? name,
    String? imageAddress,
    String? description,
    int? price,
    List<dynamic>? color,
    List<dynamic>? category,
    int? count})
  => VendorFlowerViewModel(
    id: id ?? this.id,
    name: name ?? this.name,
    imageAddress: imageAddress ?? this.imageAddress,
    description: description ?? this.description,
    price: price ?? this.price,
    color: color ?? this.color,
    category: category ?? this.category,
    count: count ?? this.count,
  );

  @override
  String toString() {
    return "VendorFlowerViewModel{id: $id, name: $name, imageAddress: $imageAddress, price: $price, color: $color, category: $category, count: $count}";
  }



}