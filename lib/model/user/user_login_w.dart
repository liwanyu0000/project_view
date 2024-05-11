class UserLoginWriteModel {
  final String userName;
  final String password;
  final String code;
  final String codeToken;
  const UserLoginWriteModel({
    required this.userName,
    required this.password,
    required this.code,
    required this.codeToken,
  });

  factory UserLoginWriteModel.fromJson(Map<String, dynamic> json) {
    return UserLoginWriteModel(
      userName: json['userName'],
      password: json['password'],
      code: json['code'],
      codeToken: json['codeToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'password': password,
      'code': code,
      'codeToken': codeToken,
    };
  }
}
