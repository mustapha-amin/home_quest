import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_quest/core/extensions.dart';

import '../core/colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.1),
          ),
          Center(
            child: const SpinKitWaveSpinner(
              color: AppColors.brown,
              size: 80,
            ).padAll(6),
          ),
        ],
      ),
    );
  }
}
