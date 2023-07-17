import 'package:flower_shop/src/pages/user/user_flower_cart/models/cart_Flower/cart_flower_view_model.dart';

class LoginUserViewModel{
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String imagePath;
  List<CartFlowerViewModel> userFlowerList;


  LoginUserViewModel({required this.id, required this.firstName,required this.lastName,required this.email, required this.password, required this.imagePath,required this.userFlowerList});

  factory LoginUserViewModel.fromJson(Map<String, dynamic> json){
    List<CartFlowerViewModel> flowerList=[];
    for(final flower in json["userFlowerList"]){
      flowerList.add(CartFlowerViewModel.fromJson(flower));
    }
    return LoginUserViewModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
        imagePath: json["imagePath"],
        userFlowerList: flowerList
    );
  }

  LoginUserViewModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? imagePath,
    List<CartFlowerViewModel>? userFlowerList
  }) => LoginUserViewModel(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    password: password ?? this.password,
    imagePath: imagePath ?? this.imagePath,
    userFlowerList: userFlowerList ?? this.userFlowerList
  );

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> flowerList = [];
    for (final flower in userFlowerList) {
      flowerList.add(flower.toJson());
    }
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "imagePath": imagePath,
      "userFlowerList": flowerList
    };
  }

}