import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/services/storage_service.dart';

class FileNotifier extends StateNotifier<File?> {
  String? fileName;
  File? file;
  final StorageService storageService;
  FileNotifier({required this.storageService}) : super(null);

  void setFile(File file) {
    state = file;
    this.file = file;
  }

  void setFileName(String name) {
    fileName = name;
    print("filename = $fileName");
  }

  Future<String> uploadFile() async {
    if (file == null || fileName == null) {
      return "https://cdn-icons-png.flaticon.com/512/5225/5225392.png";
    }
    await storageService.uploadFileWithFile(file!, fileName!);
    final fullPath = await storageService.getLinkDownloadFile(fileName!);
    file = null;
    return fullPath!;
  }
}

final fileProvider = StateNotifierProvider<FileNotifier, File?>((ref) {
  return FileNotifier(storageService: StorageService());
});
