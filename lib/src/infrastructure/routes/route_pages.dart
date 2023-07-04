import 'package:get/get_navigation/src/routes/get_route.dart';
import '../../../flower_shop.dart';
import '../../pages/login_page/commons/login_page_binding.dart';
import '../../pages/login_page/view/login_page.dart';
import '../../pages/signup_page/commons/signup_page_binding.dart';
import '../../pages/signup_page/view/signup_page.dart';
import '../../pages/user/user_flower_list/commons/user_flower_list_binding.dart';
import '../../pages/user/user_flower_list/view/user_flower_list.dart';
import '../../pages/vendor/vendor_flower_list/commons/vendor_flower_list_binding.dart';
import '../../pages/vendor/vendor_flower_list/view/vendor_flower_list.dart';

class RoutePages{
  static final List<GetPage> pages=[
    GetPage(
        name: RouteNames.loginPage,
        page: () => const LoginPage(),
        binding: LoginPageBinding(),
        children: [
          GetPage(
              name: RouteNames.signupPage,
              page: () => const SignupPage(),
              binding: SignupPageBinding()
          ),
          GetPage(
              name: RouteNames.vendorFlowerList,
              page: () => const VendorFlowerList(),
              binding: VendorFlowerListBinding()
          ),
          GetPage(
              name: RouteNames.userFlowerList,
              page: () => const UserFlowerList(),
              binding: UserFlowerListBinding()
          ),

        ]
    )
  ];
}