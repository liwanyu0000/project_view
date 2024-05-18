import 'package:project_view/model/house/house.dart';
import 'package:project_view/model/house/house_w.dart';

import '../services/http.dart';

class HouseRepo {
  final HttpService _http;
  HouseRepo(this._http);

  Future<int> addHouse(HouseWriteModel model) async {
    return await _http.post(
      '/house/addHouse',
      model.toJson(),
      decoder: (data) => data,
    );
  }

  Future<List<HouseModel>> getHousesForToken(int pageNum,
      [int pageSize = 15]) async {
    return await _http.post(
      '/house/getHousesForToken',
      {
        'pageNum': pageNum,
        'pageSize': pageSize,
      },
      decoder: (data) =>
          (data as List).map((e) => HouseModel.fromJson(e)).toList(),
    );
  }

  Future<int> deleteHouse(int id) async {
    return await _http.delete(
      '/house/deleteHouse/$id',
      decoder: (data) => data,
    );
  }

  Future<int> updateHouse(HouseWriteModel model, int id) async {
    return await _http.post(
      '/house/updateHouse/$id',
      model.toJson(),
      decoder: (data) => data,
    );
  }

  Future<HouseModel> getHouse(int id) async {
    return await _http.get(
      '/house/getHouse/$id',
      decoder: (data) => HouseModel.fromJson(data),
    );
  }

  Future<List<HouseModel>> getHouses({
    required String houseTardeType,
    required String houseTerritory,
    required int pageNum,
    String houseState = HouseModel.houseStatusPublish,
    int pageSize = 15,
  }) async {
    return await _http.post(
      '/house/getHouses',
      {
        'houseTardeType': houseTardeType,
        'houseTerritory': houseTerritory,
        'houseState': houseState,
        'pageNum': pageNum,
        'pageSize': pageSize,
      },
      decoder: (data) =>
          (data as List).map((e) => HouseModel.fromJson(e)).toList(),
    );
  }

  Future<int> reviewHouse(int id, bool canPass) {
    return _http.post(
      '/house/reviewHouse/$id',
      {'canPass': canPass},
      decoder: (data) => data,
    );
  }
}
