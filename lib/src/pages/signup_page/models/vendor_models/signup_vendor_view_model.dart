class SignupVendorViewModel{
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String imagePath;
  final List<dynamic> vendorFlowerList;

  SignupVendorViewModel({required this.id, required this.firstName,required this.lastName,required this.email, required this.password,required this.imagePath,required this.vendorFlowerList});

  factory SignupVendorViewModel.fromJson(Map<String, dynamic> json){
    return SignupVendorViewModel(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      password: json["password"],
      imagePath: json["imagePath"],
      vendorFlowerList: json["vendorFlowerList"]
    );
  }

  SignupVendorViewModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? imagePath,
    List<dynamic>? vendorFlowerList
  }) => SignupVendorViewModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      imagePath: imagePath ?? this.imagePath,
      vendorFlowerList: vendorFlowerList ?? this.vendorFlowerList
  );
}