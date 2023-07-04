class SignupUserDto{
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String imagePath;

  SignupUserDto({required this.firstName,required this.lastName,required this.email, required this.password,required this.imagePath});

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "password": password,
    "imagePath": imagePath
  };
}