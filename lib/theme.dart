/**
 * Creating custom color palettes is part of creating a custom app. The idea is to create
 * your class of custom colors, in this case `LingonColors` and then create a `ThemeData`
 * object with those colors you just defined.
 *
 * Resource:
 * A good resource would be this website: http://mcg.mbitson.com/
 * You simply need to put in the colour you wish to use, and it will generate all shades
 * for you. Your primary colour will be the `500` value.
 *
 * Colour Creation:
 * In order to create the custom colours you need to create a `Map<int, Color>` object
 * which will have all the shade values. `Color(0xFF...)` will be how you create
 * the colours. The six character hex code is what follows. If you wanted the colour
 * #114488 or #D39090 as primary colours in your theme, then you would have
 * `Color(0x114488)` and `Color(0xD39090)`, respectively.
 *
 * Usage:
 * In order to use this newly created theme or even the colours in it, you would just
 * `import` this file in your project, anywhere you needed it.
 * `import 'path/to/theme.dart';`
 */

import 'package:flutter/material.dart';

final ThemeData lingonTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch:
        MaterialColor(LingonColors.pink[400].value, LingonColors.pink),
    primaryColor: LingonColors.pink[400],
    primaryColorBrightness: Brightness.light,
    accentColor: LingonColors.green[200],
    accentColorBrightness: Brightness.light);

class LingonColors {
  LingonColors._(); // this basically makes it so you can instantiate this class
  static const Map<int, Color> pink = <int, Color>{
    50: Color(0xFFfce4ec),
    100: Color(0xFFf8bbd0),
    200: Color(0xFFf48fb1),
    300: Color(0xFFf06291),
    400: Color(0xFFec4079),
    500: Color(0xFFe91e62),
    600: Color(0xFFd81b5f),
    700: Color(0xFFc2185a),
    800: Color(0xFFad1456),
    900: Color(0xFF880e4f)
  };

  static const Map<int, Color> green = <int, Color>{
    50: Color(0xFFd9fbed),
    100: Color(0xFF9ff4d1),
    200: Color(0xFF40ecb3),
    300: Color(0xFF00e295),
    400: Color(0xFF00d681),
    500: Color(0xFF00cb6c),
    600: Color(0xFF00bb61),
    700: Color(0xFF00a853),
    800: Color(0xFF009646),
    900: Color(0xFF00752f)
  };
}
