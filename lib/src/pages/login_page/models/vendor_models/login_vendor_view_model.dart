class LoginVendorViewModel{
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String imagePath;

  LoginVendorViewModel({required this.id, required this.firstName,required this.lastName,required this.email, required this.password, required this.imagePath});

  factory LoginVendorViewModel.fromJson(Map<String, dynamic> json){
    return LoginVendorViewModel(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      password: json["password"],
      imagePath: json["imagePath"]
    );
  }
}