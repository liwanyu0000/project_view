import 'package:project_view/model/trade/trade_w.dart';

import '../model/trade/trade.dart';
import '../services/http.dart';

class TradeRepo {
  final HttpService _http;
  TradeRepo(this._http);

  Future<int> insertTrade(TradeWriteModel model) async {
    return await _http.post(
      '/Trade/insertTrade',
      model.toJson(),
      decoder: (data) => data,
    );
  }

  Future<int> updateTrade(int id, String info, [bool isTraden = false]) async {
    return await _http.post(
      '/Trade/updateTrade',
      {'id': id, 'info': info, 'isTrade': isTraden},
      decoder: (data) => data,
    );
  }

  Future<List<TradeModel>> selectTrade() async {
    return await _http.get(
      '/Trade/selectTrade',
      decoder: (data) {
        return ((data as List?) ?? [])
            .map((item) => TradeModel.fromJson(item))
            .toList();
      },
    );
  }
}
