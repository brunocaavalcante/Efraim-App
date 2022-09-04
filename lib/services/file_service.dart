import 'dart:io';
import 'dart:typed_data';
import 'package:app_flutter/pages/core/custom_exception.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FileService {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      throw CustomException("Ocorreu um erro ${e.message}");
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      throw CustomException("Ocorreu um erro ${e.message}");
    }
  }
}
