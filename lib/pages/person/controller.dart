import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../../repo/flie_repo.dart';
import '../base_page/base_controller.dart';

class PersonController extends BaseController {
  FileRepo fileRepo = FileRepo.instance;
  final RxBool _isUploading = false.obs;
  bool get isUploading => _isUploading.value;
  set isUploading(bool value) => _isUploading.value = value;

  changeAvatar() async {
    if (isUploading) return;
    isUploading = true;
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) {
      isUploading = false;
      return;
    }
    String fileUrl = await fileRepo.uploadFile(result.files.first);
    isUploading = false;
    if (await userRepo.changeAvatar(fileUrl)) {
      homeController.me = me?.copyWith(avatar: fileUrl);
    }
  }
}
