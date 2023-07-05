import 'package:flower_shop/flower_shop.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlowerApp extends StatelessWidget {
  const FlowerApp({Key? key}) : super(key: key);

  // String? stringValue;
  // Future<void> getStringValuesSF() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   stringValue = prefs.getString('role');
  // }
  //
  // String chooseInitial(){
  //   if(stringValue=="vendor"){
  //     return RouteNames.vendorFlowerList;
  //   }
  //   else if(stringValue=='user'){
  //     return RouteNames.userFlowerList;
  //   }
  //   else{
  //     return RouteNames.loginPage;
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner:false,
      initialRoute: RouteNames.loginPage,
      // initialRoute: chooseInitial(),
      getPages: RoutePages.pages,
      // translations: LocalizationService(),
      locale: const Locale('en','US'),
    );
  }
}