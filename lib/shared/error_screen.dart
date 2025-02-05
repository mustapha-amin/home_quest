import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/shared/loading_indicator.dart';
import 'package:hugeicons/hugeicons.dart';

import '../core/utils/textstyle.dart';

class ErrorScreen extends StatefulWidget {
  final String errorText;
  final VoidCallback onRefresh;
  const ErrorScreen({
    required this.errorText,
    required this.onRefresh,
    super.key,
  });

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const LoadingIndicator()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedWifiError01,
                    color: Colors.red,
                    size: 150,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Whoops\n",
                      style: kTextStyle(25, isBold: true),
                      children: [
                        TextSpan(
                          text: widget.errorText,
                          style: kTextStyle(15),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      widget.onRefresh();
                      setState(() {
                        loading = true;
                      });
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
