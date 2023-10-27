import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:greenify/services/storage_service.dart';
import 'package:greenify/states/file_notifier_state.dart';

class UploadImageContainer extends StatefulWidget {
  final FileNotifier fileNotifier;
  const UploadImageContainer({super.key, required this.fileNotifier});

  @override
  State<UploadImageContainer> createState() => _UploadImageContainerState();
}

class _UploadImageContainerState extends State<UploadImageContainer> {
  File? imageFile;
  String? imageUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.fileNotifier.imageUrl != null
        ? imageUrl = widget.fileNotifier.imageUrl
        : imageUrl = null;

    print('image URl = $imageUrl');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () async {
        final file = await StorageService().pickFile();
        if (file.name == "") {
          return;
        }
        setState(() {
          imageFile = File(file.path!);
        });
        widget.fileNotifier.setFile(imageFile!);
        widget.fileNotifier.setFileName(file.name);
      },
      child: imageFile != null
          ? Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200]),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  )),
            )
          : imageUrl != null
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200]),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl!,
                        fit: BoxFit.cover,
                      )),
                )
              : DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  dashPattern: const [8, 8],
                  color: Colors.grey,
                  strokeWidth: 2,
                  child: SizedBox(
                    height: 180,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image,
                            color: Colors.grey,
                          ),
                          Text(
                            "Tambahkan Gambar",
                            style: textTheme.bodySmall!
                                .apply(fontWeightDelta: 2, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
