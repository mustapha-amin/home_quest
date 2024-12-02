import 'dart:io';

import 'package:flutter/material.dart';

class ImagesListView extends StatelessWidget {
  final List<File> images;
  const ImagesListView({required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...images.map(
                (image) => Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(image),
                    ),
                  ),
                ),
              )
        ],
      ),
    );
  }
}
