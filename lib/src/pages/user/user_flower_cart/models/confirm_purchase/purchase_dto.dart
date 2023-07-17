import 'package:flower_shop/src/pages/user/user_flower_cart/models/cart_Flower/cart_flower_view_model.dart';


class PurchaseDto {
  List<CartFlowerViewModel> purchaseList;
  final String date;
  final int userId;

  PurchaseDto({
    required this.purchaseList,
    required this.date,
    required this.userId
  });

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> flowerList = [];
    for (final flower in purchaseList) {
      flowerList.add(flower.toJson());
    }
    return {
      "purchaseList": purchaseList,
      "date": date,
      "userId": userId
    };
  }
}