import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:project_view/pages/components/base_dialog.dart';
import 'package:project_view/pages/components/config/color_config.dart';
import 'package:project_view/pages/components/custom_loading.dart';
import 'package:project_view/pages/components/snackbar.dart';
import 'package:project_view/repo/flie_repo.dart';
import 'package:project_view/utils/adaptive.dart';

class SelectImgController {
  SelectImgController();
  FileRepo fileRepo = FileRepo.instance;
  bool isUploading = false;
  bool isSelect = false;
  final List<String> imageUrl = [];
  int count = 0;
  int upnum = 0;
  int failednum = 0;
  bool get isAction => isUploading || isSelect;
  delectImg(String url) => imageUrl.remove(url);
  addImgs(List<String> urls) => imageUrl.addAll(urls);
  clean() => imageUrl.clear();
}

class SelectImg extends StatefulWidget {
  final SelectImgController? controller;
  const SelectImg({super.key, this.controller});

  @override
  State<SelectImg> createState() => _SelectImgState();
}

class _SelectImgState extends State<SelectImg> {
  SelectImgController? _controller;
  SelectImgController get controller =>
      _controller ??= (widget.controller ?? SelectImgController());
  FileRepo get fileRepo => controller.fileRepo;
  List<String> get imageUrl => controller.imageUrl;
  bool get isUploading => controller.isUploading;
  bool get isSelect => controller.isSelect;
  int get count => controller.count;
  int get upnum => controller.upnum;
  int get failednum => controller.failednum;
  set isUploading(bool value) => controller.isUploading = value;
  set isSelect(bool value) => controller.isSelect = value;
  set count(int value) => controller.count = value;
  set upnum(int value) => controller.upnum = value;
  set failednum(int value) => controller.failednum = value;

  @override
  Widget build(BuildContext context) {
    double imgSize = min(Adaptive.getWidth(context) * .2, 96);
    return Wrap(
      children: [
        ...imageUrl.map(
          (e) => Padding(
            padding: const EdgeInsets.all(5),
            child: Stack(children: [
              GestureDetector(
                onTap: () => showSmartDialog(
                  height: Adaptive.isSmall(context)
                      ? Adaptive.getHeight(context) * .4
                      : Adaptive.getHeight(context) * .8,
                  width: Adaptive.getWidth(context) * .8,
                  child: PhotoViewGallery.builder(
                    itemCount: imageUrl.length,
                    builder: (context, index) => PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(imageUrl[index]),
                      initialScale: PhotoViewComputedScale.contained,
                    ),
                    scrollPhysics: const ClampingScrollPhysics(),
                    pageController:
                        PageController(initialPage: imageUrl.indexOf(e)),
                  ),
                ),
                child: Image.network(
                  e,
                  width: imgSize,
                  height: imgSize,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : CustomLoading(
                              width: imgSize, height: imgSize, text: '加载中...'),
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: imgSize,
                    height: imgSize,
                    alignment: Alignment.center,
                    color: labelColor(context.isDarkMode),
                    child: const Icon(Icons.error_outline),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => setState(() => controller.delectImg(e)),
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: labelColor(context.isDarkMode),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
        if (isUploading || isSelect)
          Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              height: imgSize,
              width: imgSize,
              child: CustomLoading(
                text: isUploading
                    ? '上传 $upnum / $count 张图片，失败 $failednum 张'
                    : '选择图片中...',
              ),
            ),
          ),
        if (!isSelect && !isUploading)
          Padding(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () async {
                setState(() => isSelect = true);
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.image,
                );
                setState(() {
                  isSelect = false;
                  isUploading = true;
                });
                if (result != null) {
                  setState(() => count += result.files.length);
                  List<String> errImg = [];
                  await fileRepo.uploadFiles(
                    result.files,
                    onSuccess: (urls) async {
                      for (var e in urls) {
                        setState(() => imageUrl.add(e));
                        await Future.delayed(const Duration(milliseconds: 100));
                      }
                    },
                    uploadProgress: (upnum, failednum) {
                      setState(() {
                        this.upnum += upnum;
                        this.failednum += failednum;
                      });
                    },
                    onError: (filename, error) => errImg.addAll(filename),
                  );
                  if (errImg.isNotEmpty) {
                    snackbar('上传失败：${errImg.join(', ')}');
                  }
                }
                setState(() => isUploading = false);
              },
              child: Container(
                width: imgSize,
                height: imgSize,
                color: labelColor(context.isDarkMode),
                child: const Icon(Icons.file_upload_outlined),
              ),
            ),
          ),
      ],
    );
  }
}
