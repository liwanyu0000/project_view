import 'package:project_view/model/user/change_pwd_w.dart';
import 'package:project_view/model/user/user_login_w.dart';
import 'package:project_view/model/user/user_register_w.dart';
import 'package:project_view/model/user/user_w.dart';
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

  Future<UserLoginModel> login(UserLoginWriteModel model) async {
    return await _http.post(
      '/user/login',
      model.toJson(),
      decoder: (data) => UserLoginModel.fromJson(data),
    );
  }

  Future logout() async {
    return await _http.delete('/user/logout');
  }

  Future<UserLoginModel> loginByToken() async {
    return await _http.get(
      '/user/loginByToken',
      decoder: (data) => UserLoginModel.fromJson(data),
    );
  }

  Future<bool> register(UserRegisterWriteModel model) async {
    return await _http.post(
      '/user/register',
      model.toJson(),
      decoder: (data) => data,
    );
  }

  Future<bool> changePwd(ChangePwdWriteModel model) async {
    return await _http.post(
      '/user/changePwd',
      model.toJson(),
      decoder: (data) => data,
    );
  }

  Future<bool> changeInfo(UserWriteModle model) async {
    return await _http.post(
      '/user/changeInfo',
      model.toJson(),
      decoder: (data) => data,
    );
  }

  Future<bool> changeAvatar(String? avatar) async {
    return await _http.post(
      '/user/changeInfo',
      {'avatar': avatar},
      decoder: (data) => data,
    );
  }
}
