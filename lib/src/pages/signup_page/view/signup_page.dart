import 'package:flower_shop/src/pages/signup_page/view/widget/custom_signup_form_field.dart';
import 'package:flower_shop/src/pages/signup_page/view/widget/empty_profile_picture.dart';
import 'package:flower_shop/src/pages/signup_page/view/widget/image_profile_picture.dart';
import 'package:flower_shop/src/pages/signup_page/view/widget/signup_password_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_page_controller.dart';

class SignupPage extends GetView<SignupPageController>{

  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xfff3f7f7),
          appBar: AppBar(
            backgroundColor: const Color(0xfff3f7f7),
              title: const Text("Signup",style: TextStyle(
                  color: Color(0xff050a0a),
                  fontWeight: FontWeight.w600,
                  fontSize: 23
              ),),
            iconTheme: const IconThemeData(
              color: Color(0xff050a0a),
              weight: 2,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        Obx(() => controller.imagePath.isEmpty?
                        EmptyProfilePicture(shapeSize: 150):ImageProfilePicture(shapeSize: 170)),

                        CustomSignupFormField(
                          hintText: "First Name",
                          name: "First Name",
                          controller: controller.firstNameController,
                          validator: controller.firstNameValidator,
                          icon: Icons.accessibility_outlined,
                        ),
                        CustomSignupFormField(
                          hintText: "Last Name",
                          name: "Last Name",
                          controller: controller.lastNameController,
                          validator: controller.lastNameValidator,
                          icon: Icons.accessibility_outlined,
                        ),
                        CustomSignupFormField(
                          hintText: "Email",
                          name: "Email",
                          controller: controller.emailController,
                          validator: controller.emailValidator,
                          icon: Icons.alternate_email,
                        ),
                        SignupPasswordFormField(
                          hintText: "Password",
                          name: "Password",
                          controller: controller.passwordController,
                          validator: controller.passwordValidator,
                          icon: Icons.lock_outlined,
                        ),
                        SignupPasswordFormField(
                          hintText: "Confirm Password",
                          name: "Confirm Password",
                          controller: controller.confirmPasswordController,
                          validator: controller.confirmPasswordValidator,
                          icon: Icons.verified_user_outlined,
                        ),

                        Obx(() => Row(
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: 1,
                                    groupValue: controller.selectedType.value,
                                    onChanged: controller.onChangedType
                                ),
                                const Text("I am a vendor"),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 2,
                                    groupValue: controller.selectedType.value,
                                    onChanged: controller.onChangedType
                                ),
                                const Text("I am a user"),
                              ],
                            )
                          ],
                        ))
                      ],
                    )
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6cba00),
                      ),
                      onPressed: () {
                        if(controller.selectedType.value==1){
                          controller.addVendor();
                        }
                        else{
                          controller.addUser();
                        }
                      },
                      child: Obx(() => (controller.isLoadingSignup.value) ? const Center(
                        child: SizedBox(
                            width: 50,
                            child: LinearProgressIndicator()
                        ),
                      ) : const Text("Signup"),),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
    );
  }
}