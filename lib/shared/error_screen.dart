import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:hugeicons/hugeicons.dart';

import '../core/utils/textstyle.dart';

class ErrorScreen extends ConsumerWidget {
  final String errorText;
  final VoidCallback onRefresh;
  const ErrorScreen(
      {required this.errorText, required this.onRefresh, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedWifiError01,
              color: Colors.red,
              size: 150,
            ),
            SelectableText(errorText).padX(8),
            Text.rich(
              TextSpan(
                text: "Whoops\n",
                style: kTextStyle(25, isBold: true),
                children: [
                  TextSpan(
                    text: errorText,
                    style: kTextStyle(15),
                  )
                ],
              ),
              textAlign: TextAlign.center,
            ),
            TextButton.icon(
              onPressed: onRefresh,
              label: Text(
                "Refresh",
                style: kTextStyle(16, color: Colors.blue),
              ),
              icon: const Icon(
                Icons.refresh,
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
