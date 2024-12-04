import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ImagesListView extends StatelessWidget {
  final List<File> images;
  final void Function(int index) onCancel;
  const ImagesListView({
    required this.images,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...images.map(
            (image) => Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
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
                IconButton(
                  onPressed: () => onCancel(images.indexOf(image)),
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: Colors.black.withOpacity(0.5),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
