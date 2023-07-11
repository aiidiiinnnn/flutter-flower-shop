class EditVendorFlowerDto{
  final String name;
  final String imageAddress;
  final String description;
  final int price;
  final List<dynamic> color;
  final List<dynamic> category;
  int vendorId;
  int count;
  final int id;

  EditVendorFlowerDto({
    required this.name,
    required this.imageAddress,
    required this.description,
    required this.price,
    required this.color,
    required this.category,
    required this.vendorId,
    required this.count,
    required this.id
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "imageAddress": imageAddress,
    "description": description,
    "price": price,
    "color":color,
    "category":category,
    "count":count,
    "vendorId":vendorId,
    "id":id
  };



}