class AddVendorFlowerDto{
  final int id;
  final String name;
  final String imageAddress;
  final String description;
  final int price;
  final List<dynamic> color;
  final List<dynamic> category;
  final int count;

  AddVendorFlowerDto({
    required this.id,
    required this.name,
    required this.imageAddress,
    required this.description,
    required this.price,
    required this.color,
    required this.category,
    required this.count
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "imageAddress": imageAddress,
    "description": description,
    "price": price,
    "color":color,
    "category":category,
    "count":count
  };



}