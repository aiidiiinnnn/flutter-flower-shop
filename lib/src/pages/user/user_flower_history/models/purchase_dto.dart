import '../../user_flower_cart/models/cart_flower_view_model.dart';

class PurchaseDto {
  List<CartFlowerViewModel> purchaseList;
  final String date;
  final String userName;
  final String userLastName;

  PurchaseDto(
      {required this.purchaseList,
      required this.date,
      required this.userName,
      required this.userLastName});

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> flowerList = [];
    for (final flower in purchaseList) {
      flowerList.add(flower.toJson());
    }
    return {
      "purchaseList": purchaseList,
      "date": date,
      "userName": userName,
      "userLastName": userLastName
    };
  }
}
