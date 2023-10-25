import 'package:get/get.dart';
import 'package:mybus_mobile/LocalStrings/english.dart';
import 'package:mybus_mobile/LocalStrings/hindi.dart';
import 'package:mybus_mobile/LocalStrings/kannada.dart';
import 'package:mybus_mobile/LocalStrings/telugu.dart';

//LocaleStringsList is calling from main.dart

class LocaleStringsList extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': englishLang().keys,
        'hi_IN': hindiLang().keys,
        'tg_IN': teluguLang().keys,
        'kn_IN': kannadaLang().keys
      };
}
