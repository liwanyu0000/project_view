class UserExtraInfoModel {
  static const String sexMan = "MXN";
  static const String sexWoman = "WOMAN";
  static const String sexUnknown = "UNKNOWN";

  final String sex;
  final String? birthday;
  final String? favorite;
  final String? signature;

  const UserExtraInfoModel({
    this.sex = sexUnknown,
    this.birthday,
    this.favorite,
    this.signature,
  });

  factory UserExtraInfoModel.fromJson(Map<String, dynamic> json) {
    return UserExtraInfoModel(
      sex: json['sex'] ?? sexUnknown,
      birthday: json['birthday'],
      favorite: json['favorite'],
      signature: json['signature'],
    );
  }

  Map<String, dynamic> toJson() => {
        'sex': sex,
        'birthday': birthday,
        'favorite': favorite,
        'signature': signature,
      };
}
