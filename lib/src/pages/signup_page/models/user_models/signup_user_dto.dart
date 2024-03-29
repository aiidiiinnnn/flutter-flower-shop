import 'package:flower_shop/src/pages/user/user_flower_cart/models/cart_flower_dto.dart';

class SignupUserDto{
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String imagePath;
  final List<CartFlowerDto> userFlowerList;

  SignupUserDto({required this.firstName,required this.lastName,required this.email, required this.password,required this.imagePath, required this.userFlowerList});

  Map<String, dynamic> toJson() {
    List<Map<String,dynamic>> flowerList=[];
    for(final flower in userFlowerList){
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