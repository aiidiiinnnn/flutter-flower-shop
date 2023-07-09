class LoginUserViewModel{
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String imagePath;
  final List<Map<String,dynamic>> userFlowerList;


  LoginUserViewModel({required this.id, required this.firstName,required this.lastName,required this.email, required this.password, required this.imagePath,required this.userFlowerList});

  factory LoginUserViewModel.fromJson(Map<String, dynamic> json){
    return LoginUserViewModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        password: json["password"],
        imagePath: json["imagePath"],
        userFlowerList: json["userFlowerList"]
    );
  }
}