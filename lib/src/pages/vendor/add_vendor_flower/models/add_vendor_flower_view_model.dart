class AddVendorFlowerViewModel{
  final int id;
  final String name;
  final String imageAddress;
  final String description;
  final int price;
  final List<dynamic> color;
  final List<dynamic> category;
  int vendorId;
  final int count;

  AddVendorFlowerViewModel({
    required this.id,
    required this.name,
    required this.imageAddress,
    required this.description,
    required this.price,
    required this.color,
    required this.category,
    required this.count,
    required this.vendorId
  });

  factory AddVendorFlowerViewModel.fromJson(Map<String,dynamic> json){
    return AddVendorFlowerViewModel(
        id: json["id"],
        name: json["name"],
        imageAddress: json["imageAddress"],
        description:json["description"],
        price: json["price"],
        color: json["color"],
        category: json["category"],
        count: json["count"],
        vendorId: json["vendorId"]
    );
  }

  AddVendorFlowerViewModel copyWith({
    int? id,
    String? name,
    String? imageAddress,
    String? description,
    int? price,
    List<dynamic>? color,
    List<dynamic>? category,
    int? vendorId,
    int? count})
  => AddVendorFlowerViewModel(
    id: id ?? this.id,
    name: name ?? this.name,
    imageAddress: imageAddress ?? this.imageAddress,
    description: description ?? this.description,
    price: price ?? this.price,
    color: color ?? this.color,
    category: category ?? this.category,
    vendorId: vendorId ?? this.vendorId,
    count: count ?? this.count,
  );

  @override
  String toString() {
    return "VendorFlowerViewModel{id: $id, name: $name, imageAddress: $imageAddress, price: $price, color: $color, category: $category, count: $count}";
  }



}