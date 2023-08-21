class UserFlowerDto {
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

  UserFlowerDto(
      {required this.name,
      required this.imageAddress,
      required this.description,
      required this.price,
      required this.color,
      required this.category,
      required this.vendorName,
      required this.vendorLastName,
      required this.vendorImage,
      required this.count});

  Map<String, dynamic> toJson() => {
        "name": name,
        "imageAddress": imageAddress,
        "description": description,
        "price": price,
        "color": color,
        "category": category,
        "count": count,
        "vendorName": vendorName,
        "vendorLastName": vendorLastName,
        "vendorImage": vendorImage
      };
}
