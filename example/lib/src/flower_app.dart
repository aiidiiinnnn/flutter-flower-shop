
import 'package:flower_shop/flower_shop.dart';
import 'package:flower_shop/generated/locales.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:taav_ui/taav_ui.dart';
import 'localization_service.dart';

class FlowerApp extends StatelessWidget {
  FlowerApp({super.key, required this.isLogged, required this.role});
  final bool? isLogged;
  final String? role;

  String? routeName;

  @override
  Widget build(BuildContext context) {
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
      title: 'Flower Shop Aidiiinnnn',
      builder: (final context, final child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: TaavTheme(
            theme: Themes.lightTheme(context).styleData,
            child: TaavToast(
              toastAlignment: Alignment.topCenter,
              child: child!,
            ),
          ),
        );
      },
      translationsKeys: AppTranslation.translations,
      initialRoute: isLogged == null ? RouteNames.loginPage : routeName,
      translations: LocalizationService(),
      locale: const Locale('en','US'),
      debugShowCheckedModeBanner: false,
      getPages: RoutePages.pages,
    );
  }
}