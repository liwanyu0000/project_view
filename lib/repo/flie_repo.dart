import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../services/http.dart';

class FileRepo {
  final HttpService _http;
  FileRepo(this._http);

  Future<String> uploadFile(PlatformFile file) async {
    if (file.path == null) throw '上传失败';
    MultipartFile multipartFile =
        MultipartFile(File(file.path!), filename: file.name);
    FormData data = FormData({'file': multipartFile});
    return await _http.post(
      '/upload/file',
      data,
      decoder: (data) => data,
    );
  }

  Future<List<String>> _uploadFileItem(
      List<MultipartFile> multipartFiles) async {
    FormData data = FormData({'files': multipartFiles});
    List<String> res;
    try {
      res = await _http.post(
        '/upload/files',
        data,
        decoder: (data) => (data as List).cast(),
        uploadProgress: (percent) {
          // print('upload: $percent');
        },
      );
    } catch (e) {
      res = [];
    }
    return res;
  }

  Future<List<String>> uploadFiles(
    List<PlatformFile> files, {
    dynamic Function(int upnum)? uploadProgress,
  }) async {
    List<MultipartFile> multipartFiles = [];
    List<String> ans = [];
    int count = 0;
    int upnum = 0;
    for (var file in files) {
      if (file.path == null) continue;
      File fileData = File(file.path!);
      multipartFiles.add(MultipartFile(fileData, filename: file.name));
      count += file.size;
      if (count > 1024 * 1024 * 5) {
        upnum += multipartFiles.length;
        List<String> res = await _uploadFileItem(multipartFiles);
        uploadProgress?.call(upnum);
        if (res.isEmpty) printError(info: "upload failed");
        ans.addAll(res);
        count = 0;
        multipartFiles = [];
      }
    }
    upnum += multipartFiles.length;
    List<String> res = await _uploadFileItem(multipartFiles);
    uploadProgress?.call(upnum);
    ans.addAll(res);
    return ans;
  }
}
