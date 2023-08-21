class UserFlowerSearchViewModel {
  final int id;
  final String name;
  final String imageAddress;
  final String description;
  final int price;
  final List<dynamic> color;
  final List<dynamic> category;
  final String vendorName;
  final String vendorLastName;
  final String vendorImage;
  int count;

  UserFlowerSearchViewModel(
      {required this.id,
      required this.name,
      required this.imageAddress,
      required this.description,
      required this.price,
      required this.color,
      required this.category,
      required this.vendorName,
      required this.vendorLastName,
      required this.vendorImage,
      required this.count});

  factory UserFlowerSearchViewModel.fromJson(Map<String, dynamic> json) {
    return UserFlowerSearchViewModel(
        id: json["id"],
        name: json["name"],
        imageAddress: json["imageAddress"],
        description: json["description"],
        price: json["price"],
        color: json["color"],
        category: json["category"],
        count: json["count"],
        vendorName: json["vendorName"],
        vendorLastName: json["vendorLastName"],
        vendorImage: json["vendorImage"]);
  }

  UserFlowerSearchViewModel copyWith(
          {int? id,
          String? name,
          String? imageAddress,
          String? description,
          int? price,
          List<dynamic>? color,
          List<dynamic>? category,
          String? vendorName,
          String? vendorLastName,
          String? vendorImage,
          int? count}) =>
      UserFlowerSearchViewModel(
        id: id ?? this.id,
        name: name ?? this.name,
        imageAddress: imageAddress ?? this.imageAddress,
        description: description ?? this.description,
        price: price ?? this.price,
        color: color ?? this.color,
        category: category ?? this.category,
        count: count ?? this.count,
        vendorName: vendorName ?? this.vendorName,
        vendorLastName: vendorLastName ?? this.vendorLastName,
        vendorImage: vendorImage ?? this.vendorImage,
      );
}
