import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_view/repo/flie_repo.dart';

class SelectImg extends StatefulWidget {
  const SelectImg({super.key});

  @override
  State<SelectImg> createState() => _SelectImgState();
}

class _SelectImgState extends State<SelectImg> {
  FileRepo fileRepo = FileRepo(Get.find());
  List<String> imageUrl = [];
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ...imageUrl.map((e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                e,
                width: 100,
                height: 100,
              ),
            )),
        GestureDetector(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              type: FileType.image,
            );
            if (result != null) {
              List<String> urls = await fileRepo.uploadFiles(result.files,
                  uploadProgress: (upnum) {
                print('已完成: ${upnum / result.files.length * 100}%');
              });
              setState(() => imageUrl.addAll(urls));
            }
          },
          child: Container(
            width: 100,
            height: 100,
            color: Colors.grey,
            child: const Icon(Icons.file_upload_outlined),
          ),
        ),
      ],
    );
  }
}
