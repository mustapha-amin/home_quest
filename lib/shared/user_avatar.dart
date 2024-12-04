import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String url;
  final double width, height;
  const UserAvatar({required this.url, required this.height, required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imgProvider) {
        return Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
            border: Border.all(
              color:Colors.black,
              width: 2,
            ),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: imgProvider,
            ),
          ),
        );
      },
    );
  }
}
