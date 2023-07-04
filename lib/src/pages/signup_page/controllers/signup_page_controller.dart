import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_models/signup_user_dto.dart';
import '../models/user_models/signup_user_view_model.dart';
import '../models/vendor_models/signup_vendor_dto.dart';
import '../models/vendor_models/signup_vendor_view_model.dart';
import '../repositories/signup_page_repository.dart';

class SignupPageController extends GetxController {
  final SignupPageRepository _repository = SignupPageRepository();
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  RxInt selectedType = 1.obs;
  RxString imagePath=''.obs;

  String? firstNameValidator(final String? firstName) {
    if (firstName == null || firstName.isEmpty) {
      return "Please enter your first Name";
    }
    return null;
  }

  String? lastNameValidator(final String? lastName) {
    if (lastName == null || lastName.isEmpty) {
      return "Please enter your last Name";
    }
    return null;
  }

  String? emailValidator(final String? email) {
    if (email == null || email.isEmpty) {
      return "Please enter your email address";
    }
    return null;
  }

  String? passwordValidator(final String? password) {
    if (password == null || password.isEmpty) {
      return "please enter your password";
    }
    else if (password != confirmPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  String? confirmPasswordValidator(final String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "please enter your password";
    }
    else if (confirmPassword != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  void onChangedType(int? chosenType) {
    selectedType.value = chosenType!;
  }

  Future<void> addVendor() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final dto = SignupVendorDto(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      password: confirmPasswordController.text,
      imagePath: imagePath.value
    );
    final Either<String, SignupVendorViewModel> request = await _repository
        .addVendor(dto);
    request.fold(
            (left) => print(left),
            (right) =>
            Get.back(
                result: {
                  "id": right.id,
                  "firstName": right.firstName,
                  "lastName": right.lastName,
                  "email": right.email,
                  "password": right.password,
                  "imagePath": right.imagePath
                }
            )
    );
  }

  Future<void> addUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final dto = SignupUserDto(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      password: confirmPasswordController.text,
      imagePath: imagePath.value
    );
    final Either<String, SignupUserViewModel> request = await _repository
        .addUser(dto);
    request.fold(
            (left) => print(left),
            (right) =>
            Get.back(
                result: {
                  "id": right.id,
                  "firstName": right.firstName,
                  "lastName": right.lastName,
                  "email": right.email,
                  "password": right.password,
                  "imagePath": right.imagePath
                }
            )
    );
  }

  Future<void> imageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      imagePath.value=pickedImage.path.toString();
      update();
    }
    else {
      print('No image selected.');
    }
  }

  Future<void> imageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      imagePath.value=pickedImage.path.toString();
      update();
    }
    else {
      print('No image selected.');
    }
  }

}