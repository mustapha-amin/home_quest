import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';

import '../core/colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: const SpinKitWaveSpinner(
          color: AppColors.brown,
          size: 80,
        ).padAll(6),
      ),
    );
  }
}
