import 'package:flutter/material.dart';

import 'colors_app.dart';
import 'text_styles.dart';

class AppStyle {
  static AppStyle? _instance;
  // Avoid self isntance
  AppStyle._();
  static AppStyle get instance {
    _instance ??= AppStyle._();
    return _instance!;
  }

  ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        backgroundColor: ColorsApp.instance.prymary,
        textStyle: TextStyles.instance.textButtonLabel,
      );
}

extension AppStyleExtension on BuildContext {
  AppStyle get appStyle => AppStyle.instance;
}
