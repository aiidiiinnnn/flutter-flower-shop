import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../flower_shop.dart';
import '../models/user_models/login_user_view_model.dart';
import '../models/vendor_models/login_vendor_view_model.dart';
import '../repositories/login_page_repository.dart';

class LoginPageController extends GetxController {
  RxList<LoginUserViewModel> usersList = RxList();
  RxList<LoginVendorViewModel> vendorList = RxList();
  final LoginPageRepository _repository = LoginPageRepository();
  final GlobalKey<FormState> formKey = GlobalKey();
  RxBool isLoading = true.obs;
  RxBool isChecked = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String chosenRole="";
  @override
  void onInit(){
    super.onInit();
  }

  String? emailValidator(final String? email) {
    if (email == null || email.isEmpty) {
      return "Please enter your email address";
    }
    if(!RegExp(r'\S+@\S+\.\S+').hasMatch(email)){
      return "Please enter a valid email address";
    }
    return null;
  }

  String? passwordValidator(final String? password) {
    if (password == null || password.isEmpty) {
      return "please enter your password";
    }
    return null;
  }

  void handleRememberMe(String role,bool value) {
    isChecked.value = value;
    SharedPreferences.getInstance().then(
          (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('role', role);
      },
    );
    isChecked.value = value;
  }
  void handleLogin(String role) {
    SharedPreferences.getInstance().then(
          (prefs) {
        prefs.setString('role', role);
      },
    );
  }

  void saveVendor(int id){
    SharedPreferences.getInstance().then(
          (prefs) {
        prefs.setInt("vendorId", id);
      },
    );
  }

  void saveUser(int id){
    SharedPreferences.getInstance().then(
          (prefs) {
        prefs.setInt("userId", id);
      },
    );
  }

  Future<void> goToSignup() async {
    final result = await Get.toNamed("${RouteNames.loginPage}${RouteNames.signupPage}");
    final bool isSignedUp = result != null;
    if(isSignedUp){
      emailController.text=result["email"];
      passwordController.text=result["password"];
    }
  }

  Future<void> getVendor() async {
    isLoading.value = true;
    final Either<String, List<LoginVendorViewModel>> vendors = await _repository
        .getVendors();
    vendors.fold(
            (left) {
          print(left);
          isLoading.value = false;
        },
            (right) {
          vendorList.addAll(right);
          isLoading.value = false;
        }
    );
  }

  Future<void> getUsers() async {
    isLoading.value = true;
    final Either<String, List<LoginUserViewModel>> users = await _repository
        .getUsers();
    users.fold(
            (left) {
          print(left);
          isLoading.value = false;
        },
            (right) {
          usersList.addAll(right);
          isLoading.value = false;
        }
    );
  }

  Future<void> getVendorByEmail() async {
    isLoading.value = true;
    final Either<String, List<LoginVendorViewModel>> vendors = await _repository
        .getVendorByEmailPassword(
        email: emailController.text, password: passwordController.text);
    vendors.fold(
            (left) {
          print(left);
          isLoading.value = false;
        },
            (right) {
          vendorList.addAll(right);
          isLoading.value = false;
        }
    );
  }

  Future<void> getUserByEmail() async {
    isLoading.value = true;
    final Either<String, List<LoginUserViewModel>> users = await _repository
        .getUserByEmailPassword(
        email: emailController.text, password: passwordController.text);
    users.fold(
            (left) {
          print(left);
          isLoading.value = false;
        },
            (right) {
          usersList.addAll(right);
          isLoading.value = false;
        }
    );
  }

  RxBool isLoadingLogin=false.obs;
  Future<void> goToNextPage() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoadingLogin.value=true;
    isLoading.value = true;
    final Either<String, List<LoginVendorViewModel>> vendorsByEmailPassword = await _repository.getVendorByEmailPassword(email: emailController.text, password: passwordController.text);
    final Either<String, List<LoginUserViewModel>> usersByEmailPassword = await _repository.getUserByEmailPassword(email: emailController.text, password: passwordController.text);
    vendorsByEmailPassword.fold(
            (left) {
          print(left);
          isLoadingLogin.value=false;
          isLoading.value = false;
        },
            (right) {
          if(right.isNotEmpty){
            for(final loginVendor in right){
              if(emailController.text!=loginVendor.email){
                Get.snackbar('Email', 'Entered email has not found V');
              }
              else{
                if(passwordController.text!=loginVendor.password){
                  Get.snackbar('Password', 'Password is wrong U');
                }
                else{
                  chosenRole ="vendor";
                  if(isChecked.value){
                    handleRememberMe(chosenRole, isChecked.value);
                  }
                  else{
                    handleLogin(chosenRole);
                  }
                  saveVendor(loginVendor.id);
                  Get.offAndToNamed(RouteNames.vendorFlowerList);
                }
              }
            }
          }
          else{
            usersByEmailPassword.fold(
                    (left) {
                  print(left);
                  isLoading.value = false;
                },
                    (right) {
                  if(right.isNotEmpty){
                    for(final loginUser in right){
                      if(emailController.text!=loginUser.email){
                        Get.snackbar('Email', 'Entered email has not found U');
                      }
                      else{
                        if(passwordController.text!=loginUser.password){
                          Get.snackbar('Password', 'Password is wrong U');
                        }
                        else{
                          chosenRole ="user";
                          if(isChecked.value){
                            handleRememberMe(chosenRole, isChecked.value);
                          }
                          else{
                            handleLogin(chosenRole);
                          }
                          saveUser(loginUser.id);
                          Get.offAndToNamed(RouteNames.userFlowerList);
                        }
                      }
                    }
                  }
                  else{
                    Get.snackbar('Email', 'has not found');
                  }
                  isLoadingLogin.value=false;
                  isLoading.value = false;
                }
            );
          }
          isLoadingLogin.value=false;
          isLoading.value = false;
        }
    );
  }

}
