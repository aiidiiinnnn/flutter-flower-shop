import 'cart_flower_view_model.dart';

class CartFlowerDto{
  final String name;
  final String imageAddress;
  final String description;
  final int price;
  final List<dynamic> color;
  final List<dynamic> category;
  int vendorId;
  int count;
  int totalCount;

  CartFlowerDto({
    required this.name,
    required this.imageAddress,
    required this.description,
    required this.price,
    required this.color,
    required this.category,
    required this.vendorId,
    required this.count,
    required this.totalCount
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
    "totalCount":totalCount
  };

  factory CartFlowerDto.fromViewModel(CartFlowerViewModel viewModel){
    return CartFlowerDto(
        name: viewModel.name,
        imageAddress: viewModel.imageAddress,
        description: viewModel.description,
        price: viewModel.price,
        color: viewModel.color,
        category: viewModel.category,
        vendorId: viewModel.vendorId,
        count: viewModel.count,
        totalCount: viewModel.totalCount
    );
  }


}