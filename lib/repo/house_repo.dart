import '../services/http.dart';

class HouseRepo {
  final HttpService _http;
  HouseRepo(this._http);

  Future<bool> addHouse(Map<String, dynamic> json) async {
    return await _http.post(
      '/house/addHouse',
      json,
      decoder: (data) => data,
    );
  }
}
