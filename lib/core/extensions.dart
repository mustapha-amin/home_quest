import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension NavExts on BuildContext {
  void push(Widget screen) {
    Navigator.push(this, MaterialPageRoute(builder: (context) => screen));
  }

  void pop() {
    Navigator.pop(this);
  }

  void replace(Widget screen) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

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

  Widget centeralize() => Center(
        child: this,
      );
}

extension MoneyExts on num {
  String get toMoney {
    return NumberFormat.currency(symbol: '₦', decimalDigits: 0).format(this);
  }

  String get toMoneyNoSymb {
    return NumberFormat.currency(symbol: '', decimalDigits: 0).format(this);
  }
}

extension StringExts on String {
  String get captializeFirst => this[0].toUpperCase() + substring(1);
}
