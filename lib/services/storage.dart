import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  Future<String> uploadFile() async {
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf', 'doc'],
      );

      if (res == null) return "Failed";
      final file = res.files.first;
      File selectedFile = File(file.path!);

      FirebaseStorage fStorage = FirebaseStorage.instance;

      await fStorage.ref('uploads/${file.name}').putFile(selectedFile);
      return file.name;
    } on FirebaseException catch (e) {
      print(e);
      throw Exception('Error occured!');
    }
  }

  Future<String?> getLinkDownloadFile(String url) async {
    try {
      FirebaseStorage fStorage = FirebaseStorage.instance;

      String downloadURL = await fStorage
          .ref('uploads/$url')
          .getDownloadURL()
          .then((value) => value.toString());
      return downloadURL;
    } on FirebaseException catch (e) {
      print(e);
      throw Exception('Error occured!');
    }
  }

  Future<void> deleteFile(String? url) async {
    try {
      FirebaseStorage fStorage = FirebaseStorage.instance;
      if (url == "" || url == null) {
        print("Null $url");
        return;
      }
      if (url.contains("https://lh3.googleusercontent.com/")) {
        return;
      }

      await fStorage.refFromURL(url).delete();
    } on FirebaseException {
      throw Exception('Error occured!');
    }
  }
}
