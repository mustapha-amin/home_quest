import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ImageFullScreen extends StatelessWidget {
  final String url;
  const ImageFullScreen({required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Hero(
        tag: url,
        child: Image.network(
          url,
          height: 80.h,
          width: 100.w,
        ),
      ),
    );
  }
}
