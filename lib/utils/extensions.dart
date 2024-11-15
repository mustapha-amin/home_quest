import 'package:flutter/material.dart';

extension WidgetExts on Widget {
  Widget padX(double size) => Padding(
        padding: EdgeInsets.symmetric(horizontal: size),
        child: this,
      );

  Widget padY(double size) => Padding(
        padding: EdgeInsets.symmetric(vertical: size),
        child: this,
      );

  Widget padAll(double size) => Padding(
        padding: EdgeInsets.all(size),
        child: this,
      );
}
