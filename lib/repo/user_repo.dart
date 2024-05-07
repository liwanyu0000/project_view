import 'package:project_view/model/user/verify_code.dart';

import '../model/user/user_login.dart';
import '../services/http.dart';

class UserRepo {
  final HttpService _http;
  UserRepo(this._http);

  Future<VerifyCodeModel> getCode() async {
    return await _http.get(
      '/verify/getCode',
      decoder: (data) => VerifyCodeModel.fromJson(data),
    );
  }

  Future<UserLoginModel> login(Map<String, dynamic> json) async {
    return await _http.post(
      '/user/login',
      json,
      decoder: (data) => UserLoginModel.fromJson(data),
    );
  }

  Future<bool> register(Map<String, dynamic> json) async {
    return await _http.post(
      '/user/register',
      json,
      decoder: (data) => data,
    );
  }

  Future<bool> changePwd(Map<String, dynamic> json) async {
    return await _http.post(
      '/user/changePwd',
      json,
      decoder: (data) => data,
    );
  }
}
