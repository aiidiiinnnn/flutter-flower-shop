class SignupUserDto{
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String imagePath;
  final List<dynamic> userFlowerList;

  SignupUserDto({required this.firstName,required this.lastName,required this.email, required this.password,required this.imagePath, required this.userFlowerList});

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "password": password,
    "imagePath": imagePath,
    "userFlowerList": userFlowerList
  };
}