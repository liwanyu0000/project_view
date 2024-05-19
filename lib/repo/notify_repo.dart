import 'package:project_view/model/message/message_w.dart';

import '../model/notify.dart';
import '../services/http.dart';

class NotifyRepo {
  final HttpService _http;
  NotifyRepo(this._http);

  Future<NotifyModel> creat() async {
    return await _http.get(
      '/notify/create',
      decoder: (data) => NotifyModel.fromJson(data),
    );
  }

  Future<bool> send(MessageWriteModel model) async {
    return await _http.post(
      '/notify/send',
      model.toJson(),
      decoder: (data) => data,
    );
  }

  Future<bool> keep(String channel) async {
    return await _http.get(
      '/notify/keep/$channel',
      decoder: (data) => data,
    );
  }

  Future<bool> delete(String channel) async {
    return await _http.delete(
      '/notify/delete/$channel',
      decoder: (data) => data,
    );
  }
}
