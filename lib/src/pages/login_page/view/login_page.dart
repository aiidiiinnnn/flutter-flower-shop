import 'package:flower_shop/src/pages/login_page/view/widget/custom_login_form_field.dart';
import 'package:flower_shop/src/pages/login_page/view/widget/login_password_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_page_controller.dart';

class LoginPage extends GetView<LoginPageController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xfff3f7f7),
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          decorationIcon(),
          emailAndPassword(),
          rememberMe(),
          loginButton(),
          signupPrompt(),
        ]),
      ),
    ));
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: const Color(0xfff3f7f7),
      title: const Text(
        "Login",
        style: TextStyle(
            color: Color(0xff050a0a),
            fontWeight: FontWeight.w600,
            fontSize: 23),
      ),
    );
  }

  Padding decorationIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xff7f8283)),
          child: const Icon(Icons.person, color: Colors.white, size: 120),
        ),
      ),
    );
  }

  Form emailAndPassword() {
    return Form(
        key: controller.formKey,
        child: Column(
          children: [
            CustomLoginFormField(
              hintText: "Email",
              name: "Email",
              controller: controller.emailController,
              validator: controller.emailValidator,
              icon: Icons.accessibility_outlined,
            ),
            LoginPasswordFormField(
              hintText: "Password",
              name: "Password",
              controller: controller.passwordController,
              validator: controller.passwordValidator,
              icon: Icons.lock_outlined,
            ),
          ],
        ));
  }

  Padding rememberMe() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 24.0,
              width: 24.0,
              child: Theme(
                data: ThemeData(unselectedWidgetColor: Colors.blue),
                child: Obx(
                  () => Checkbox(
                      value: controller.isChecked.value,
                      onChanged: (value) {
                        controller.isChecked.value = value!;
                      }),
                ),
              )),
          const SizedBox(width: 10.0),
          const Text("Remember Me",
              style: TextStyle(
                  color: Color(0xff050a0a), fontSize: 12, fontFamily: 'Rubric'))
        ],
      ),
    );
  }

  Widget loginButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6cba00),
            ),
            onPressed: controller.login,
            child: Obx(
              () => (controller.isLoadingLogin.value)
                  ? const Center(
                      child:
                          SizedBox(width: 50, child: LinearProgressIndicator()),
                    )
                  : const Text("Login"),
            ),
          ),
        ),
      );

  Widget signupPrompt() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(color: Color(0xff050a0a), fontSize: 12),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () => controller.goToSignup(),
            child: const Text(
              'Signup',
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          ),
        ],
      );
}
