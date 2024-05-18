import 'package:project_view/model/user/user.dart';

import '../model/communicate/communicate.dart';
import '../model/communicate/communicate_item.dart';
import '../services/http.dart';

class CommunicateRepo {
  final HttpService _http;
  CommunicateRepo(this._http);

  Future<bool> addCommunicate(CommunicateItemModel model, int id) async {
    return await _http.post(
      '/Communicate/addCommunicate',
      {
        "content": model.toStr(),
        "userIdTwo": id,
      },
      decoder: (data) => data,
    );
  }

  Future<CommunicateModel?> getCommunicate(int id, int pageNum) async {
    return await _http.post(
      '/Communicate/getCommunicate',
      {"pageNum": pageNum, "userIdTwo": id},
      decoder: (data) => data == null ? null : CommunicateModel.fromJson(data),
    );
  }

  Future<List<BaseUserModel>> getCommunicateList() async {
    return await _http.get(
      '/Communicate/getCommunicateList',
      decoder: (data) => ((data as List?) ?? [])
          .map((e) => BaseUserModel.fromJson(e))
          .toList(),
    );
  }
}
