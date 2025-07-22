import 'package:flutter/material.dart';
import 'package:moneynest/core/constants/app_font_weights.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle get semibold => copyWith(
        fontVariations: [AppFontWeights.semiBold],
      );

  TextStyle get bold => copyWith(
        fontVariations: [AppFontWeights.bold],
      );
}
