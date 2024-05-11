class ChangePwdWriteModel {
  final String oldPassword;
  final String password;
  final String secondPassword;
  final String code;
  final String codeToken;
  const ChangePwdWriteModel({
    required this.oldPassword,
    required this.password,
    required this.secondPassword,
    required this.code,
    required this.codeToken,
  });

  factory ChangePwdWriteModel.fromJson(Map<String, dynamic> json) {
    return ChangePwdWriteModel(
      oldPassword: json['oldPassword'],
      password: json['password'],
      secondPassword: json['secondPassword'],
      code: json['code'],
      codeToken: json['codeToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oldPassword': oldPassword,
      'password': password,
      'secondPassword': secondPassword,
      'code': code,
      'codeToken': codeToken,
    };
  }
}
