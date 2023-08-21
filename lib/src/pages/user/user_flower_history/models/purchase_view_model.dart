import '../../user_flower_cart/models/cart_flower_view_model.dart';

class PurchaseViewModel {
  final int id;
  List<CartFlowerViewModel> purchaseList;
  final String date;
  final String userName;
  final String userLastName;

  PurchaseViewModel(
      {required this.purchaseList,
      required this.date,
      required this.id,
      required this.userName,
      required this.userLastName});

  factory PurchaseViewModel.fromJson(Map<String, dynamic> json) {
    List<CartFlowerViewModel> purchaseList = [];
    for (final flower in json["purchaseList"]) {
      purchaseList.add(CartFlowerViewModel.fromJson(flower));
    }
    return PurchaseViewModel(
      id: json["id"],
      date: json["date"],
      userName: json["userName"],
      userLastName: json["userLastName"],
      purchaseList: purchaseList,
    );
  }
}
