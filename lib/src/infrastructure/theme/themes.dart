import 'package:flutter/material.dart';
import 'package:taav_ui/taav_ui.dart';

class Themes {
  Themes._();

  static String fontFamilyPrimary(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'fa'
          ? 'IRANSans'
          : 'Roboto';

  static TaavThemeBuilder lightTheme(BuildContext _) => TaavThemeBuilder(
        primaryColor: Colors.blue,
        textColor: const Color(0xff050a0a),
        backgroundColor: const Color(0xfff3f7f7),
      )..addStyleData(testStyles());

  static TaavThemeBuilder darkTheme(BuildContext _) => TaavThemeBuilder(
        primaryColor: const MaterialColor(0xFF42bd86, <int, Color>{
          50: Color(0xFFe9f7f1),
          100: Color(0xFFdaf1e7),
          200: Color(0xFFb5e3cf),
          300: Color(0xFF90d5b7),
          400: Color(0xFF6bc79f),
          500: Color(0xFF42bd86),
          600: Color(0xFF35976b),
          700: Color(0xFF287150),
          800: Color(0xFF1b4b35),
          900: Color(0xFF0e251b)
        }),
        onPrimaryColor: Colors.white,
        secondaryColor: const Color(0xFFb99095),
        accentColor: Colors.blue,
        backgroundColor: const Color(0xfff3f7f7),
        lightBackgroundColor: const Color(0xFF527a78),
        selectedColor: const Color(0xFF293d3c),
        textColor: const Color(0xff050a0a),
        disabledColor: const Color(0xFFB7B7B7),
        dangerColor: const Color(0xFFFE5E73),
        warningColor: Colors.amber,
        infoColor: const Color(0xFF8FB8EB),
        successColor: const Color(0xFF57B894),
        buttonShape: TaavWidgetShape.semiRound,
        brightness: Brightness.dark,
      )..addStyleData(testStyles());

  static StyleData testStyles() => TaavTextStyleData(
        themeName: const TaavTextThemeName('textAmin'),
        fontFamily: 'textOverline-fontFamilyPrimary',
        fontSize: 'textOverline-fontSize',
        fontWeight: 'textOverline-fontWeight',
        textColor: TaavColors.green,
      ).toStyleData()
        ..inject(TaavButtonStyles.sampleGradient())
        ..inject(
          TaavIconButtonStyleData(
            themeName: 'iconButtonAmin',
            backgroundColor: const TaavStateColor(
              normalColor: Color(0xff050a0a),
              pressedColor: Color(0xff050a0a),
              disabledColor: 'textBase-disabledColor',
            ),
            borderColor: const TaavStateColor(
              normalColor: TaavColors.red,
              pressedColor: TaavColors.blue,
              disabledColor: 'textBase-disabledColor',
            ),
            borderWidth: 0.0,
            iconColor: TaavStateColor(
              normalColor: TaavColors.blue[700],
              pressedColor: TaavColors.purple,
              disabledColor: 'textBase-disabledColor',
            ),
            shadowColor: TaavColors.grey,
            splashColor: TaavColors.grey[200],
            elevation: 4.0,
          ).toStyleData(),
        )
        ..inject(TaavIconButtonStyles.sampleGradient())
        ..inject(
          TaavRadioStyleData.toStyle(
            themeName: 'radioThemeTest',
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            labelTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: TaavColors.white,
            ),
            radioColor: TaavColors.black,
            backgroundColor: Colors.blueGrey,
            disabledColor: 'themeBase-disabledColor',
            splashColor: Colors.grey,
            containerShape: TaavWidgetShape.semiRound,
          ),
        )
        ..inject(
          TaavCheckboxStyleData.toStyle(
            themeName: 'checkboxThemeTest',
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            labelTextStyle: _checkboxLabelTextStyleBuilder,
            checkBackgroundColor: TaavColors.orange,
            backgroundColor: Colors.blueGrey,
            tickColor: TaavColors.red,
            disabledColor: 'themeBase-disabledColor',
            splashColor: Colors.grey,
            containerShape: kDefaultShape,
          ),
        );

  static TextStyle _checkboxLabelTextStyleBuilder(final StyleData style) =>
      TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: style.get<Color>('textBase-contentColor'),
      );
}
