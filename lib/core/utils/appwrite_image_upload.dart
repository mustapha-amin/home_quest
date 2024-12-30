import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:home_quest/core/utils/image_url_util.dart';

Future<String> uploadImage(Storage storage, File file, String bucketId,) async {
    try {
      final imageUrl = await storage.createFile(
        bucketId: bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(
            path: file.path, filename: file.path.split('/').last),
      );
      return genImageUrl(imageUrl.$id, bucketId);
    } on AppwriteException catch (e) {
      log(e.toString());
      throw Exception("Error uploading image");
    }
  }