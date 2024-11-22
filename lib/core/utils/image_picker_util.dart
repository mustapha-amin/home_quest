import 'dart:developer';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

Future<Either<String, File>> pickImage() async {
  ImagePicker imagePicker = ImagePicker();
  try {
    final xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    return right(File(xFile!.path));
  } catch (e) {
    return(left(e.toString()));
  }
}

Future<Either<String, List<File?>>> pickImages() async {
  ImagePicker imagePicker = ImagePicker();
  try {
    final xFile = await imagePicker.pickMultiImage();
    return(right(xFile.map((e) => File(e.path)).toList()));
  } catch (e) {
    return(left(e.toString()));
  }
  
}
