import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_view/utils/area.dart';

import '../../../model/house/house.dart';
import '../../../model/house/house_info.dart';
import '../area_filter.dart';
import '../config/config.dart';
import '../select_popmenu.dart';
import '../snackbar.dart';
import 'base_from_view.dart';
import '../from_view/from_item.dart';

class FilterController {
  FilterController();

  /// 地址
  final AreaFilterController _addrCode = AreaFilterController();
  AreaFilterController get addrCodeText => _addrCode;
  String? get addrCode => _addrCode.code;

  /// 租金或售价
  final TextEditingController _maxPrice = TextEditingController();
  TextEditingController get maxPriceText => _maxPrice;
  double? get maxPrice =>
      _maxPrice.text.isEmpty ? null : double.tryParse(_maxPrice.text);
  final TextEditingController _minPrice = TextEditingController();
  TextEditingController get minPriceText => _minPrice;
  double? get minPrice =>
      _minPrice.text.isEmpty ? null : double.tryParse(_minPrice.text);

  /// 付款方式（租）
  final SelectController _rentPayType = SelectController(
    const [
      SelectData(label: '月付', data: RentHouseInfo.rentPayMonth),
      SelectData(label: '季付', data: RentHouseInfo.rentPayQuarter),
      SelectData(label: '半年付', data: RentHouseInfo.rentPayHalfYear),
      SelectData(label: '年付', data: RentHouseInfo.rentPayYear),
    ],
  );
  SelectController get rentPayTypeText => _rentPayType;
  List<String> get rentPayType => _rentPayType.selectValue;

  /// 租房类型
  final SelectController _rentType = SelectController(
    const [
      SelectData(label: "整租", data: RentHouseInfo.rentTypeWhole),
      SelectData(label: "合租", data: RentHouseInfo.rentTypeJoint),
    ],
  );
  SelectController get rentTypeText => _rentType;
  List<String> get rentType => _rentType.selectValue;

  /// 付款方式（售）
  final SelectController _buyPayType = SelectController(
    const [
      SelectData(label: "一次性付款", data: BuyHouseInfo.buyPayOnce),
      SelectData(label: "按揭", data: BuyHouseInfo.buyPayMortgage),
      SelectData(label: "分期", data: BuyHouseInfo.buyPayInstallment),
    ],
  );
  SelectController get buyPayTypeText => _buyPayType;
  List<String> get buyPayType => _buyPayType.selectValue;

  /// 面积
  final TextEditingController _maxArea = TextEditingController();
  TextEditingController get maxAreaText => _maxArea;
  double? get maxArea =>
      _maxArea.text.isEmpty ? null : double.tryParse(_maxArea.text);
  final TextEditingController _minArea = TextEditingController();
  TextEditingController get minAreaText => _minArea;
  double? get minArea =>
      _minArea.text.isEmpty ? null : double.tryParse(_minArea.text);

  /// 搜索
  final TextEditingController _description = TextEditingController();
  TextEditingController get descriptionText => _description;
  String? get description =>
      _description.text.isEmpty ? null : _description.text;

  /// 验证数据是否正确
  bool validate() {
    if (maxPrice != null && minPrice != null && maxPrice! < minPrice!) {
      return false;
    }
    if (maxArea != null && minArea != null && maxArea! < minArea!) {
      return false;
    }
    return true;
  }

  /// 清空数据
  void clear() {
    _addrCode.reset();
    _maxPrice.clear();
    _minPrice.clear();
    _maxArea.clear();
    _minArea.clear();
    _description.clear();
    _rentPayType.clear();
    _rentType.clear();
    _buyPayType.clear();
  }

  void dispose() {
    _addrCode.dispose();
    _maxPrice.dispose();
    _minPrice.dispose();
    _maxArea.dispose();
    _minArea.dispose();
    _description.dispose();
    _rentPayType.dispose();
    _rentType.dispose();
    _buyPayType.dispose();
  }

  bool get isEmpty =>
      addrCode == null &&
      maxPrice == null &&
      minPrice == null &&
      maxArea == null &&
      minArea == null &&
      description == null &&
      rentPayType.isEmpty &&
      rentType.isEmpty &&
      buyPayType.isEmpty;

  /// 筛选
  bool filter(HouseModel model) {
    BuyHouseInfo? buyHouseInfo;
    RentHouseInfo? rentHouseInfo;
    if (model.houseTardeType == HouseModel.sellHouse) {
      buyHouseInfo = model.houseInfo as BuyHouseInfo;
    } else {
      rentHouseInfo = model.houseInfo as RentHouseInfo;
    }
    if (addrCode != null && !model.houseAddrCode.startsWith(addrCode!)) {
      return false;
    }
    if (maxPrice != null && model.housePrice > maxPrice!) {
      return false;
    }
    if (minPrice != null && model.housePrice < minPrice!) {
      return false;
    }
    if (rentPayType.isNotEmpty && rentHouseInfo != null) {
      bool flag = false;
      for (String payType in rentPayType) {
        if (rentHouseInfo.rentPayType.contains(payType)) flag = true;
      }
      if (!flag) return false;
    }
    if (rentType.isNotEmpty && rentHouseInfo != null) {
      bool flag = false;
      for (String payType in rentType) {
        if (rentHouseInfo.rentType.contains(payType)) flag = true;
      }
      if (!flag) return false;
    }
    if (buyPayType.isNotEmpty && buyHouseInfo != null) {
      bool flag = false;
      for (String payType in buyPayType) {
        if (buyHouseInfo.buyPayType.contains(payType)) flag = true;
      }
      if (!flag) return false;
    }
    if (maxArea != null &&
        buyHouseInfo != null &&
        buyHouseInfo.houseArea > maxArea!) {
      return false;
    }
    if (minArea != null &&
        buyHouseInfo != null &&
        buyHouseInfo.houseArea < minArea!) {
      return false;
    }
    if (description != null &&
        !model.houseInfo.decoration.contains(description!) &&
        !model.houseAddr.contains(description!)) {
      return false;
    }
    return true;
  }
}

class FilterView extends BaseFromView {
  final String? houseTerritory;
  final String? houseTradeType;
  final List<Widget> items;
  final dynamic Function(FilterController filter)? onFilter;
  const FilterView({
    super.key,
    this.houseTerritory,
    this.houseTradeType,
    this.items = const [],
    this.onFilter,
  });

  FilterController get houseFilter => controller.houseFilter;

  ProvinceAreaNode? get node {
    if (houseTerritory == null || (houseTerritory?.isEmpty ?? true)) {
      return null;
    }
    AreaNode? node = controller.area?.findFromCode(houseTerritory!);
    if (node is ProvinceAreaNode) return node;
    return null;
  }

  Widget _creatText(
    context, {
    required String hintText,
    TextEditingController? controller,
  }) =>
      Flexible(
        child: TextFormField(
          decoration: decorationConfig(
            context,
            hintText: hintText,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9]+[.]?[0-9]*'))
          ],
          controller: controller,
        ),
      );

  @override
  List<Widget> creatItems(BuildContext context, GlobalKey<FormState> formKey) {
    return [
      if (node != null)
        FromItem(
          label: "位置：",
          child: AreaFilter(
            province: node!,
            controller: houseFilter.addrCodeText,
            initNode: houseFilter.addrCode,
          ),
        ),
      if (houseTradeType == HouseModel.rentHouse) ...[
        FromItem(
          label: "租金：",
          child: Row(
            children: [
              _creatText(context,
                  hintText: "最低租金", controller: houseFilter.minPriceText),
              const SizedBox(width: 10),
              const Text('至'),
              const SizedBox(width: 10),
              _creatText(context,
                  hintText: "最高租金", controller: houseFilter.maxPriceText),
            ],
          ),
        ),
        FromItem(
          label: "租房类型",
          child: SelectPopMenu(
            canMultiple: true,
            controller: houseFilter.rentTypeText,
          ),
        ),
        FromItem(
          label: "付款方式",
          key: UniqueKey(),
          child: SelectPopMenu(
            canMultiple: true,
            controller: houseFilter.rentPayTypeText,
          ),
        )
      ],
      if (houseTradeType == HouseModel.sellHouse) ...[
        FromItem(
          label: "价格：",
          child: Row(
            children: [
              _creatText(context,
                  hintText: "最低价格", controller: houseFilter.minPriceText),
              const SizedBox(width: 10),
              const Text('至'),
              const SizedBox(width: 10),
              _creatText(context,
                  hintText: "最高价格", controller: houseFilter.maxPriceText),
            ],
          ),
        ),
        FromItem(
          label: "面积：",
          child: Row(
            children: [
              _creatText(context,
                  hintText: "最小面积", controller: houseFilter.minAreaText),
              const SizedBox(width: 10),
              const Text('至'),
              const SizedBox(width: 10),
              _creatText(context,
                  hintText: "最大面积", controller: houseFilter.maxAreaText),
            ],
          ),
        ),
        FromItem(
          label: "付款方式",
          child: SelectPopMenu(
            key: UniqueKey(),
            canMultiple: true,
            controller: houseFilter.buyPayTypeText,
          ),
        )
      ],
      ...items,
      FromItem(
        label: "搜索",
        child: TextFormField(
          decoration: decorationConfig(context, hintText: "请输入描述或详细地址"),
          controller: houseFilter.descriptionText,
        ),
      ),
      FromItem(
        label: '',
        child: Align(
          alignment: Alignment.centerRight,
          child: creatButon(
            context,
            label: "筛选",
            width: 64,
            onTap: () => hookExceptionWithSnackbar(
              () async {
                if (!formKey.currentState!.validate() ||
                    !houseFilter.validate()) {
                  throw "数据格式错误";
                }
                onFilter?.call(houseFilter);
              },
            ),
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return creatFrom(context);
  }
}
