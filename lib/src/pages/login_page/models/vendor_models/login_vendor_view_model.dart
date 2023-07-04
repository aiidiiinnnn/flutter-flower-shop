class LoginVendorViewModel{
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  LoginVendorViewModel({required this.id, required this.firstName,required this.lastName,required this.email, required this.password});

  factory LoginVendorViewModel.fromJson(Map<String, dynamic> json){
    return LoginVendorViewModel(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      password: json["password"]
    );
  }
}