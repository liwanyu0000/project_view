import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../services/http.dart';

class FileRepo {
  final HttpService _http;
  FileRepo._(this._http);
  static FileRepo? _instance;
  static FileRepo get instance {
    _instance ??= FileRepo._(Get.find());
    return _instance!;
  }

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
    return _http.post(
      '/upload/files',
      data,
      decoder: (data) => (data as List).cast(),
    );
  }

  /// 注意： 上传的单个文件不能超过10MB
  Future<List<String>> uploadFiles(
    List<PlatformFile> files, {
    dynamic Function(int upnum, int failednum)? uploadProgress,
    dynamic Function(List<String> filename, String error)? onError,
    dynamic Function(
      List<String> urls,
    )? onSuccess,
  }) async {
    List<MultipartFile> multipartFiles = [];
    List<String> ans = [];
    int count = 0;
    int failednum = 0;
    for (var file in files) {
      if (file.path == null || file.size > 1024 * 1024 * 10) {
        failednum++;
        onError?.call([file.name], 'file size too large or path is null');
        continue;
      }
      File fileData = File(file.path!);
      multipartFiles.add(MultipartFile(fileData, filename: file.name));
      count += file.size;
      if (count > 1024 * 1024 * 5) {
        List<String> res;
        try {
          res = await _uploadFileItem(multipartFiles);
        } catch (e) {
          onError?.call(
            multipartFiles.map((e) => e.filename).toList(),
            e.toString(),
          );
          failednum += multipartFiles.length;
          res = [];
        }
        uploadProgress?.call(res.length, failednum);
        failednum = 0;
        count = 0;
        multipartFiles = [];
        if (res.isNotEmpty) {
          onSuccess?.call(res);
          ans.addAll(res);
        }
      }
    }
    List<String> res;
    if (multipartFiles.isEmpty) return ans;
    try {
      res = await _uploadFileItem(multipartFiles);
    } catch (e) {
      onError?.call(
        multipartFiles.map((e) => e.filename).toList(),
        e.toString(),
      );
      failednum += multipartFiles.length;
      res = [];
    }
    uploadProgress?.call(res.length, failednum);
    if (res.isEmpty) return ans;
    onSuccess?.call(res);
    ans.addAll(res);
    return ans;
  }
}
