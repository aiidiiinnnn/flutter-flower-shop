import 'package:get/get.dart';
import 'package:flower_shop/generated/locales.g.dart' as locale;

class LocalizationService extends Translations{
  Map<String, String> fa={};
  Map<String, String> en={};

  LocalizationService(){
    fa.addAll(locale.Locales.fa_IR);
    en.addAll(locale.Locales.en_US);
  }

  @override
  Map<String, Map<String,String>> get keys => {
    'fa':fa,
    'en':en
  };
}