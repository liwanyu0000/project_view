import 'package:project_view/model/user/user.dart';

import 'communicate_item.dart';

class CommunicateModel {
  static const String endText = '<CommunicateitemEnd>';

  final BaseUserModel userModelOne;
  final BaseUserModel userModelTwo;
  final String content;
  final DateTime creatTime;
  final List<CommunicateItemModel> _items = [];
  final List<CommunicateItemModel> _newItems = [];
  int get pageNum => _items.length ~/ 20;
  bool get isEnd => _items.length % 20 != 0;
  bool get isEmpty => _items.isEmpty && _newItems.isEmpty;

  int get userIdOne => userModelOne.id;
  int get userIdTwo => userModelTwo.id;

  static List<CommunicateItemModel> _getItem(String content) {
    List<String> items =
        content.split(endText).where((e) => e.isNotEmpty).toList();
    return items.map((e) => CommunicateItemModel.fromStr(e)).toList()
      ..sort((a, b) => a.time.compareTo(b.time));
  }

  List<CommunicateItemModel> get items => [..._items, ..._newItems];

  int getUserId(int myid) =>
      userModelOne.id == myid ? userModelTwo.id : userModelOne.id;

  // 添加新消息
  add(CommunicateItemModel model) => _newItems.add(model);

  // 添加历史消息
  addALL(List<CommunicateItemModel> models) => _items.addAll(models);

  CommunicateModel({
    required this.userModelOne,
    required this.userModelTwo,
    required this.content,
    required this.creatTime,
  });

  factory CommunicateModel.fromJson(Map<String, dynamic> json) {
    return CommunicateModel(
      userModelOne: BaseUserModel.fromJson(json['userModelOne']),
      userModelTwo: BaseUserModel.fromJson(json['userModelTwo']),
      content: json['content'] ?? '',
      creatTime: DateTime.parse(json['creatTime']),
    );
  }
}
