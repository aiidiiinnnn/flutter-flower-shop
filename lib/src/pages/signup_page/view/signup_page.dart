import 'package:flower_shop/src/pages/signup_page/view/widget/custom_signup_form_field.dart';
import 'package:flower_shop/src/pages/signup_page/view/widget/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../controllers/signup_page_controller.dart';

class SignupPage extends GetView<SignupPageController>{

  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xff314657),
          appBar: AppBar(
            backgroundColor: const Color(0xffb32437),
            title: const Text("Signup"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        ProfilePicture(shapeSize: 150),
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
                          icon: Icons.accessibility_outlined,
                        ),
                        CustomSignupFormField(
                          hintText: "Password",
                          name: "Password",
                          controller: controller.passwordController,
                          validator: controller.passwordValidator,
                          icon: Icons.lock_outlined,
                          obscureText: true,
                        ),
                        CustomSignupFormField(
                          hintText: "Confirm Password",
                          name: "Confirm Password",
                          controller: controller.confirmPasswordController,
                          validator: controller.confirmPasswordValidator,
                          icon: Icons.verified_user_outlined,
                          obscureText: true,
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

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff5B3596),
                  ),
                  onPressed: () => {
                    if(controller.selectedType.value==1){
                      controller.addVendor()
                    },
                    controller.addUser()
                  },
                  child: const Text('Signup'),
                ),
              ],
            ),
          ),
        ),
    );
  }
}