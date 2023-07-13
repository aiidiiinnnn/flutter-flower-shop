import 'package:flower_shop/src/pages/user/user_flower_cart/view/user_flower_cart.dart';
import 'package:flower_shop/src/pages/vendor/add_vendor_flower/view/add_vendor_flower.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/screens/vendor_flower_profile.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/screens/vendor_flower_search.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/vendor_flower_list.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../../../flower_shop.dart';
import '../../pages/login_page/commons/login_page_binding.dart';
import '../../pages/login_page/view/login_page.dart';
import '../../pages/signup_page/commons/signup_page_binding.dart';
import '../../pages/signup_page/view/signup_page.dart';
import '../../pages/user/user_flower_cart/commons/user_flower_cart_binding.dart';
import '../../pages/user/user_flower_list/commons/user_flower_list_binding.dart';
import '../../pages/user/user_flower_list/view/screens/user_flower_home.dart';
import '../../pages/user/user_flower_list/view/screens/user_flower_profile.dart';
import '../../pages/user/user_flower_list/view/user_flower_list.dart';
import '../../pages/vendor/add_vendor_flower/commons/add_vendor_flower_binding.dart';
import '../../pages/vendor/edit_vendor_flower/commons/edit_vendor_flower_binding.dart';
import '../../pages/vendor/edit_vendor_flower/view/edit_vendor_flower.dart';
import '../../pages/vendor/vendor_flower_list/commons/vendor_flower_list_binding.dart';
import '../../pages/vendor/vendor_flower_list/view/screens/vendor_flower_home.dart';


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
        ]
    ),

    GetPage(
        name: RouteNames.vendorFlowerList,
        page: () => const VendorFlowerList(),
        binding: VendorFlowerListBinding(),
        children: [
          GetPage(
              name: RouteNames.vendorFlowerHome,
              page: () => const VendorFlowerHome(),
              binding: VendorFlowerListBinding(),
              children: [
                GetPage(
                    name: RouteNames.addVendorFlower,
                    page: () => const AddVendorFlower(),
                    binding: AddVendorFlowerBinding()
                ),
                GetPage(
                    name: RouteNames.editVendorFlower,
                    page: () => const EditVendorFlower(),
                    binding: EditVendorFlowerBinding()
                ),
              ]
          ),
          GetPage(
              name: RouteNames.vendorFlowerProfile,
              page: () => const VendorFlowerProfile(),
              binding: VendorFlowerListBinding(),
          ),
          GetPage(
            name: RouteNames.vendorFlowerSearch,
            page: () => const VendorFlowerSearch(),
            binding: VendorFlowerListBinding(),
          ),
        ]
    ),

    GetPage(
        name: RouteNames.userFlowerList,
        page: () => const UserFlowerList(),
        binding: UserFlowerListBinding(),
        children: [
          GetPage(
            name: RouteNames.userFlowerHome,
            page: () => const UserFlowerHome(),
            binding: UserFlowerListBinding(),
            children: [
              GetPage(
                name: RouteNames.userFlowerCart,
                page: () => const UserFlowerCart(),
                binding: UserFlowerCartBinding(),
              ),
            ]
          ),
          GetPage(
            name: RouteNames.userFlowerProfile,
            page: () => const UserFlowerProfile(),
            binding: UserFlowerListBinding(),
          ),
        ]
    ),
  ];
}