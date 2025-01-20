import 'package:flutter/material.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/image_path.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AttributionWidget extends StatelessWidget {
  const AttributionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: SizedBox(
                height: 30.h,
                width: 90.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Powered by Mapbox Maps",
                      style: kTextStyle(18, isBold: true),
                    ),
                    attribution(context, "MAPBOX",
                        'https://www.mapbox.com/about/maps', true),
                    attribution(context, "OPENSTREETMAP",
                        'https://www.openstreetmap.org/about/', true),
                    attribution(context, "IMPROVE THIS MAP",
                        'https://www.labs.mapbox.com/contribute/'),
                    attribution(context, "MAPBOX TELEMETRY", '.'),
                    attribution(context, "MAPBOX PRIVACY POLICY",
                        'https://www.mapbox.com/legal/privacy#product-privacy/'),
                  ],
                ).padX(15),
              ),
            );
          }),
      child: Row(
        children: [
          Image.asset(
            ImagePaths.mapbox,
            width: 20.w,
          ),
          HugeIcon(
            icon: HugeIcons.strokeRoundedInformationCircle,
            color: Colors.white,
            size: 20,
          )
        ],
      ).padAll(4),
    );
  }
}

Widget attribution(BuildContext context, String text, String link,
    [bool withCopyright = false]) {
  return InkWell(
      onTap: () async {
        if (text == "MAPBOX TELEMETRY") {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actionsAlignment: MainAxisAlignment.spaceBetween,
                title: Text("Make Mapbox Maps Better"),
                content: Text(
                    "You're helping to make OpenStreetMap and Mapbox maps better by contributing anonymous usage data"),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await launchUrl(
                            Uri.parse('https://www.mapbox.com/telemetry'));
                      },
                      child: Text("More info")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Stop participating")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Participate")),
                ],
              );
            },
          );
        } else {
          await launchUrl(Uri.parse(link));
        }
      },
      child: Row(
        children: [
          if (withCopyright)
            HugeIcon(
              icon: HugeIcons.strokeRoundedCopyright,
              color: Colors.blue[900]!,
              size: 13,
            ),
          if (withCopyright) const SizedBox(width: 5),
          Text(
            text,
            style: kTextStyle(13, color: Colors.blue[800]!),
          )
        ],
      ));
}
