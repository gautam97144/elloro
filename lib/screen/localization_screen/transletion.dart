import 'dart:core';
import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'en_uk.dart';
import 'en_us.dart';

class TranslationsUtils extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {'en_US': enUs, 'en_GB': enUk};
}
