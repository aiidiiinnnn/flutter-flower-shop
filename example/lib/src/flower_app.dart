import 'package:flower_shop/flower_shop.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlowerApp extends StatelessWidget {
  const FlowerApp({Key? key}) : super(key: key);

  // String? stringValue;
  // Future getStringValuesSF() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   stringValue = prefs.getString('role');
  // }
  //
  // bool? isLogged;
  // Future getBoolValuesSF() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   isLogged = prefs.getBool('remember_me');
  // }


  @override
  Widget build(BuildContext context) {
    // String? routeName;
    //
    // if(stringValue=="vendor"){
    //   routeName = RouteNames.vendorFlowerList;
    // }
    // else if(stringValue=='user'){
    //   routeName = RouteNames.userFlowerList;
    // }
    // else{
    //   routeName = RouteNames.loginPage;
    // }
    return GetMaterialApp(
      debugShowCheckedModeBanner:false,
      // initialRoute: isLogged == null ? RouteNames.loginPage : routeName,
      initialRoute: RouteNames.loginPage,
      getPages: RoutePages.pages,
      // translations: LocalizationService(),
      locale: const Locale('en','US'),
    );
  }
}