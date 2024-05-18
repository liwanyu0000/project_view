import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:project_view/model/house/house.dart';
import 'package:project_view/model/house/house_info.dart';
import 'package:project_view/pages/components/from_view/from_Item.dart';
import 'package:project_view/pages/components/custom_tool_tip.dart';
import 'package:project_view/utils/area.dart';

import '../../../utils/utils.dart';
import '../base_dialog.dart';
import '../config/config.dart';
import '../custom_loading.dart';
import '../customize_widget.dart';
import 'base_from_view.dart';

class ShowHouseInfoView extends BaseFromView {
  final HouseModel model;
  final Function(bool pass)? onDone;
  // final bool
  const ShowHouseInfoView(this.model, {super.key, this.onDone});

  double get imgSize => max(Adaptive.getWidth() * .2, 255);

  Widget _creatText(
    BuildContext context,
    String text, {
    int maxLines = 1,
  }) =>
      CustomToolTip(
        text: text,
        child: Text(text, maxLines: maxLines, overflow: TextOverflow.ellipsis),
      );

  AreaNode? get addr => controller.area?.findFromCode(model.houseAddrCode);

  Widget _creatBut(
    BuildContext context,
    bool pass,
  ) =>
      CustomizeWidget(
        label: pass ? '通过' : '不通过',
        onTap: () => ok(() async {
          bool res = await controller.reviewHouse(model.id, pass);
          if (res) onDone?.call(pass);
          return res;
        }),
        config: CustomizeWidgetConfig(
          height: 46,
          haveBorder: true,
          backgroundColor: pass ? Theme.of(context).primaryColor : Colors.red,
          borderColor: pass ? Theme.of(context).primaryColor : Colors.red,
          primaryColor: Theme.of(context).canvasColor,
          width: 64,
        ),
      );

  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) {
    return [
      FromItem(
        label: '位置：',
        child: _creatText(context,
            "${addr?.province}  ${addr?.city}  ${addr?.county} ${addr?.street}"),
      ),
      FromItem(
        label: "详细地址",
        child: _creatText(context, model.houseAddr),
      ),
      FromItem(
          label: "交易方式", child: _creatText(context, model.houseTardeType.tr)),
      FromItem(
        label: "价格",
        child: _creatText(
          context,
          "${model.housePrice}${model.houseTardeType == HouseModel.sellHouse ? '元/平米' : '元/月'}",
        ),
      ),
      if (model.houseTardeType == HouseModel.sellHouse) ...[
        FromItem(
          label: "支付方式",
          child: _creatText(
              context, (model.houseInfo as BuyHouseInfo).payTypeText),
        ),
        FromItem(
          label: "面积",
          child: _creatText(
              context, "${(model.houseInfo as BuyHouseInfo).houseArea}平米"),
        ),
      ],
      if (model.houseTardeType == HouseModel.rentHouse) ...[
        FromItem(
          label: "支付方式",
          child: _creatText(
              context, (model.houseInfo as RentHouseInfo).payTypeText),
        ),
        FromItem(
          label: "租房类型",
          child: _creatText(
              context, (model.houseInfo as RentHouseInfo).rentType.tr),
        ),
      ],
      FromItem(
        label: "房屋描述",
        child: _creatText(context, model.houseInfo.decoration, maxLines: 3),
      ),
      Wrap(
        children: model.houseFileList
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () => showSmartDialog(
                    height: Adaptive.isSmall(context)
                        ? Adaptive.getHeight(context) * .4
                        : Adaptive.getHeight(context) * .8,
                    width: Adaptive.getWidth(context) * .8,
                    child: PhotoViewGallery.builder(
                      itemCount: model.houseFileList.length,
                      builder: (context, index) => PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(model.houseFileList[index]),
                        initialScale: PhotoViewComputedScale.contained,
                      ),
                      scrollPhysics: const ClampingScrollPhysics(),
                      pageController: PageController(
                          initialPage: model.houseFileList.indexOf(e)),
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
                                width: imgSize,
                                height: imgSize,
                                text: '加载中...'),
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: imgSize,
                      height: imgSize,
                      alignment: Alignment.center,
                      color: labelColor(context.isDarkMode),
                      child: const Icon(Icons.error_outline),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
      if (onDone != null)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _creatBut(context, false),
            const SizedBox(width: 10),
            _creatBut(context, true),
          ],
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return creatFrom(context);
  }
}

Future<dynamic> toShowHouse(HouseModel model,
        [bool isPage = true, Function(bool pass)? onDone]) async =>
    toFrom(
      ShowHouseInfoView(model, onDone: onDone),
      '详情',
      isPage,
      Adaptive.getWidth() * .6,
    );
