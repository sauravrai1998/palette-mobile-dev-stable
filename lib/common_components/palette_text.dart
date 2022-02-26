import 'dart:io';

import 'package:flutter/material.dart';

class PaletteText extends Text {
  PaletteText(
    String data, {
    TextStyle? style,
    StrutStyle? strutStyle,
    double? textScaleFactor,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) : super(
          data,
          style: style,
          textScaleFactor: textScaleFactor,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
        );

  @override
  double get textScaleFactor =>
      super.textScaleFactor ?? (Platform.isIOS ? 1.8 : 2.0);

  @override
  TextStyle? get style => super.style;

  @override
  TextAlign? get textAlign => super.textAlign;

  @override
  TextDirection? get textDirection => super.textDirection;

  @override
  Locale? get locale => super.locale;

  @override
  bool? get softWrap => super.softWrap;

  @override
  TextOverflow? get overflow => super.overflow;

  @override
  int? get maxLines => super.maxLines;

  @override
  String? get semanticsLabel => super.semanticsLabel;

  @override
  TextWidthBasis? get textWidthBasis => super.textWidthBasis;

  @override
  TextHeightBehavior? get textHeightBehavior => super.textHeightBehavior;
}
