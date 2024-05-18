import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/area.dart';
import '../../utils/utils.dart';
import '../components/from_view/filter_view.dart';
import '../components/from_view/login_register_view.dart';
import '../components/area_filter.dart';
import '../components/config/config.dart';
import '../components/custom_loading.dart';
import '../components/customize_widget.dart';
import '../components/house_card.dart';
import '../components/select_popmenu.dart';
import 'base_house_controller.dart';

abstract class BaseHouseView<T extends BaseHouseController> extends GetView<T> {
  const BaseHouseView({super.key});

  Widget viewBuild(BuildContext context);

  List<Widget> selectTrade(
    BuildContext context,
    void Function(ProvinceAreaNode e)? onSelected,
  ) =>
      controller.rootArea != null
          ? [
              const Text('地区：'),
              ProvinceFilter(
                area: controller.rootArea!,
                onSelected: onSelected,
              ),
            ]
          : [];
  List<Widget> buildExternHeadItem(BuildContext context) => [];

  Widget creatHead(
    BuildContext context, {
    void Function(ProvinceAreaNode e)? onTrade,
    void Function(SelectData)? onTerritory,
    void Function()? clean,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('地区：'),
              Obx(() => controller.rootArea != null
                  ? ProvinceFilter(
                      area: controller.rootArea!,
                      onSelected: onTrade,
                      controller: controller.houseTerritoryController,
                    )
                  : const SizedBox()),
              const SizedBox(width: 20),
              const Text('交易类型：'),
              SelectPopMenu(
                width: 100,
                controller: controller.houseTradeTypeController,
                onSelect: onTerritory,
              ),
              ...buildExternHeadItem(context),
              Obx(
                () => CustomizeWidget(
                  icon: controller.isExpanded
                      ? Icons.filter_alt
                      : Icons.filter_alt_outlined,
                  label: controller.isExpanded ? '收起筛选条件' : '展开筛选条件',
                  onTap: () => controller.isExpanded = !controller.isExpanded,
                  config: CustomizeWidgetConfig(
                    iconSize: iconSizeConfig.bigAvatarIconSize,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                ),
              ),
              CustomizeWidget(
                icon: Icons.clear,
                label: '清除筛选条件',
                onTap: clean,
                config: CustomizeWidgetConfig(
                  iconSize: iconSizeConfig.bigAvatarIconSize,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      );

  List<Widget> buildExternFilterItem(BuildContext context) => [];

  Widget buildFilter(BuildContext context) => Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
          height: controller.isExpanded ? Adaptive.getHeight(context) * .4 : 0,
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(10),
              color: context.isDarkMode
                  ? const Color(0xff20212e)
                  : const Color(0xfff3f5f7),
              child: FilterView(
                houseTerritory: controller.houseTerritory,
                houseTradeType: controller.houseTradeType,
                items: buildExternFilterItem(context),
                onFilter: (filter) {
                  if (filter.isEmpty) return;
                  if (!controller.isLoad) controller.filterData();
                  controller.isExpanded = false;
                },
              )),
        ),
      );

  Widget buildHouses(BuildContext context) => Flexible(
        child: Obx(
          () => ListView(
            shrinkWrap: true,
            children: [
              ...controller.showModels.map(
                (index) {
                  final e = controller.houseModels[index];
                  return HouseCard(
                      model: e,
                      isOwner: controller.me?.id == e.houseOwner.id,
                      isAdmin: controller.me?.isAdmin ?? false,
                      operate: (key) => controller.houseOperate(key, index));
                },
              ),
              if (controller.isLoad) const CustomLoading(text: '加载中...'),
              if (controller.isEmpty && !controller.isLoad)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      '没有数据',
                      style:
                          TextStyle(fontSize: textSizeConfig.bigTitleTextSize),
                    ),
                  ),
                ),
              if (controller.isEnd && !controller.isEmpty && !controller.isLoad)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      '没有更多了',
                      style:
                          TextStyle(fontSize: textSizeConfig.bigTitleTextSize),
                    ),
                  ),
                ),
              if (!controller.isEnd && !controller.isLoad)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextButton(
                      onPressed: controller.getData,
                      child: Text(
                        '加载更多',
                        style: TextStyle(
                            fontSize: textSizeConfig.bigTitleTextSize),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  List<Widget> houseItem(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLogin
          ? viewBuild(context)
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    color: labelColor(context.isDarkMode),
                    size: iconSizeConfig.hugAvatarIconSize,
                  ),
                  const SizedBox(height: 20),
                  const Text('你还未登录，请先登录'),
                  const SizedBox(height: 20),
                  CustomizeWidget(
                    label: '登录/注册',
                    onTap: () => toLogin(Adaptive.isSmall(context)),
                    config: CustomizeWidgetConfig(
                      haveBorder: true,
                      width: 100,
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      borderColor: Theme.of(context).colorScheme.primary,
                      primaryColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
