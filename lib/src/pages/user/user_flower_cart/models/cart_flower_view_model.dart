class CartFlowerViewModel {
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
  int totalCount;

  CartFlowerViewModel(
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
      required this.count,
      required this.totalCount});

  factory CartFlowerViewModel.fromJson(Map<String, dynamic> json) {
    return CartFlowerViewModel(
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
        vendorImage: json["vendorImage"],
        totalCount: json["totalCount"]);
  }

  CartFlowerViewModel copyWith(
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
          int? count,
          int? totalCount}) =>
      CartFlowerViewModel(
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
          totalCount: totalCount ?? this.totalCount);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageAddress": imageAddress,
        "description": description,
        "price": price,
        "color": color,
        "category": category,
        "count": count,
        "vendorName": vendorName,
        "vendorLastName": vendorLastName,
        "vendorImage": vendorImage,
        "totalCount": totalCount
      };
}
