class UserRegisterWriteModel {
  final String userName;
  final String password;
  final String secondPassword;
  final String? nickName;
  final String? emails;
  final String? phones;
  final String code;
  final String codeToken;
  const UserRegisterWriteModel({
    required this.userName,
    required this.password,
    required this.secondPassword,
    required this.nickName,
    required this.emails,
    required this.phones,
    required this.code,
    required this.codeToken,
  });

  factory UserRegisterWriteModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterWriteModel(
      userName: json['userName'],
      password: json['password'],
      secondPassword: json['secondPassword'],
      nickName: json['nickName'],
      emails: json['emails'],
      phones: json['phones'],
      code: json['code'],
      codeToken: json['codeToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
      'secondPassword': secondPassword,
      'nickName': nickName,
      'emails': emails,
      'phones': phones,
      'code': code,
      'codeToken': codeToken,
    };
  }
}
