import 'package:flower_shop/src/pages/login_page/view/widget/custom_login_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_page_controller.dart';

class LoginPage extends  GetView<LoginPageController>{

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xff314657),
          appBar: AppBar(
            backgroundColor: const Color(0xffb32437),
            title: const Text("Login"),
          ),
          body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: const Color(0xff2a3945), width: 7)
                      ),
                      child: Container(
                        height:150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          // color: const Color(0xff2a3945)
                        ),
                        child: const Icon(Icons.person_outline,color: Colors.white,size: 100),
                      ),
                    ),
                  ),
                  Form(
                      // key: controller.formKey,
                      child: Column(
                        children: [
                          CustomLoginFormField(
                            hintText: "Email",
                            name: "Email",
                            controller: controller.emailController,
                            validator: controller.emailValidator,
                            icon: Icons.accessibility_outlined,
                          ),
                          CustomLoginFormField(
                            hintText: "Password",
                            name: "Password",
                            controller: controller.passwordController,
                            validator: controller.passwordValidator,
                            icon: Icons.lock_outlined,
                            obscureText: true,
                          ),
                        ],
                      )
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: const Color(0xff00C8E8)
                              ),
                              child: Obx(() => Checkbox(
                                  value: controller.isChecked.value,
                                  onChanged: (value) {
                                    controller.isChecked.value=value!;
                                  }
                              ),),
                          )),
                      const SizedBox(width: 10.0),
                      const Text("Remember Me", style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Rubric')
                      )
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?",style: TextStyle(
                          color: Colors.white,
                          fontSize: 12
                      ),),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () => controller.goToSignup(),
                        child: const Text('Signup',style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14
                        ),),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff71cc47),
                        ),
                        onPressed: controller.goToNextPage,
                        child: const Text('Login'),
                      ),
                    ),
                  ),
                ]
            ),
          ),
        )
    );
  }

}