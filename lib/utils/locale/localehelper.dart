import 'dart:ui';

class LocaleHelper
{
  static Locale defaultLocale= const Locale("en","US");
  static Locale currentLocale = defaultLocale;


  static void setLocale(Locale locale)
  {
    currentLocale = locale;
  }
}