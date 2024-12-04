import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../core/utils/textstyle.dart';

class ErrorScreen extends ConsumerWidget {
  final ProviderBase providerToRefresh;
  const ErrorScreen({required this.providerToRefresh, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedWifiDisconnected01,
              color: Colors.red,
              size: 150,
            ),
            Text.rich(
              TextSpan(
                text: "Whoops\n",
                style: kTextStyle(25, isBold: true),
                children: [
                  TextSpan(
                    text:
                        "No internet connection was found\nCheck your internet connection and try again",
                    style: kTextStyle(15),
                  )
                ],
              ),
              textAlign: TextAlign.center,
            ),
            TextButton.icon(
              onPressed: () {
                ref.invalidate(providerToRefresh!);
              },
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
