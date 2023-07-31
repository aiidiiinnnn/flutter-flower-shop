import 'package:flower_shop/flower_shop.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'localization_service.dart';

class FlowerApp extends StatelessWidget {
  const FlowerApp({super.key, required this.isLogged, required this.role});
  final bool? isLogged;
  final String? role;

  @override
  Widget build(BuildContext context) {
    String? routeName;
    if(role=="vendor"){
      routeName = RouteNames.vendorFlowerList;
    }
    else if(role=='user'){
      routeName = RouteNames.userFlowerList;
    }
    else{
      routeName = RouteNames.loginPage;
    }
    return GetMaterialApp(
      debugShowCheckedModeBanner:false,
      initialRoute: isLogged == null ? RouteNames.loginPage : routeName,
      getPages: RoutePages.pages,
      translations: LocalizationService(),
      locale: const Locale('en','US'),
    );
  }
}