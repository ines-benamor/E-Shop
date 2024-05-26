import 'package:flutter/material.dart';

Color primaryColor = Colors.deepPurple;
Color defBgColor = "#FCE8E2".toColor();
Color backgroundColor = "#0F172A".toColor();
Color fontPrimary = ("#2A190D".toColor()).withOpacity(0.9);
Color accentColor = "#062149".toColor();
Color lightAccentColor = "#E2F5FA".toColor();
Color lightRedColor = "#FCF0F0".toColor();
Color greyFont = "#616161".toColor();
Color greenColor = "#1AA138".toColor();
Color redColor = "#EC5757".toColor();
Color indicatorColor = "#BAB8B8".toColor();
Color itemGreyColor = "#E8E6E5".toColor();
// Color orangeColor = "#FF8F27".toColor();
Color orangeColor = "#F1A11E".toColor();

Color greyButtonColor = "#ECECEC".toColor();
Color appBarColor = "#FEE3E4".toColor();
Color black40 = "#7C7C7C".toColor();
Color dividerColor = "#E6E6E6".toColor();
Color redFontColor = "#F44144".toColor();
Color redBgColor = "#FFE9E9".toColor();
Color yellowBgColor = "#FFF2D3".toColor();
Color unAvailableColor = "#E6E6E6".toColor();
Color slotSelectedColor = "#FFB4B4".toColor();
Color darkGreyColor = "#2D2D2D".toColor();

Color cardColor = "#FFFBF8".toColor();
Color shadowColor = Colors.black12;
Color greyIconColor = "#BEC4D3".toColor();

getFontColor(BuildContext context) {
  return getCurrentTheme(context).textTheme.titleMedium!.color;
}

getFontBlackColor(BuildContext context) {
  return getCurrentTheme(context).textTheme.titleLarge!.color;
}

getFontGreyColor(BuildContext context) {
  return getCurrentTheme(context).textTheme.titleSmall!.color;
}

getCardColor(BuildContext context) {
  return getCurrentTheme(context).cardColor;
}

getGreyCardColor(BuildContext context) {
  return getCurrentTheme(context).indicatorColor;
}

ThemeData getLightThemeData() {
  return ThemeData(
      scaffoldBackgroundColor: "#FFFFFF".toColor(),
      textTheme: TextTheme(
        titleMedium: TextStyle(color: "#000000".toColor()),
        titleSmall: TextStyle(color: "#737272".toColor()),
        titleLarge: TextStyle(color: "#000000".toColor()),
      ),
      hoverColor: "#F7F7FF".toColor(),
      cardColor: "#FFFFFF".toColor(),
      dialogBackgroundColor: "#FFFFFF".toColor(),
      unselectedWidgetColor: "#B9C1D3".toColor(),
      focusColor: Colors.transparent,
      hintColor: "#9B9B9B".toColor(),
      disabledColor: "#525E7B".toColor(),
      canvasColor: "#F7F8FB".toColor(),
      dividerColor: "#D7DDEC".toColor(),
      indicatorColor: "#f7f7f7".toColor(),
      shadowColor: const Color.fromRGBO(131, 157, 216, 0.11999999731779099),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: accentColor)
          .copyWith(background: "#E5E5E5".toColor()));
}

ThemeData getDarkThemeData() {
  return ThemeData(
      scaffoldBackgroundColor: "#161E2D".toColor(),
      hoverColor: "#21F6F7FF".toColor(),
      dialogBackgroundColor: "#283048".toColor(),
      focusColor: Colors.transparent,
      unselectedWidgetColor: "#525E7B".toColor(),
      cardColor: "#2D354F".toColor(),
      dividerColor: "#2B354D".toColor(),
      canvasColor: "#525E7B".toColor(),
      indicatorColor: "#F9F9F9".toColor(),
      hintColor: "#A6ADBE".toColor(),
      disabledColor: "#FFFFFF".toColor(),
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.4699999988079071),
      textTheme: TextTheme(
        titleMedium: TextStyle(color: "#FFFFFF".toColor()),
        titleSmall: TextStyle(color: "#A6ADBE".toColor()),
        titleLarge: TextStyle(color: "#FFFFFF".toColor()),
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: accentColor)
          .copyWith(background: "#161E2D".toColor()));
}

Color getAccentColor(BuildContext context) {
  return getCurrentTheme(context).colorScheme.secondary;
}

Color getSecondaryColor(BuildContext context) {
  return getCurrentTheme(context).primaryColorLight;
}

getFontHint(BuildContext context) {
  return getCurrentTheme(context).hintColor;
}

getDeActiveColor(BuildContext context) {
  return getCurrentTheme(context).indicatorColor;
}

ThemeData getCurrentTheme(BuildContext context) {
  return Theme.of(context);
}

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
