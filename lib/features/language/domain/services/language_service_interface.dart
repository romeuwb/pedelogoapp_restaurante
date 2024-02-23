import 'package:flutter/material.dart';

abstract class LanguageServiceInterface {
  updateHeader(Locale locale);
  Locale getLocaleFromSharedPref();
  void saveLanguage(Locale locale);
}