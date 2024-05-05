class UserWriteModle {
  final String username;
  final String password;
  final String nickname;
  final String? email;
  final String? phone;
  final String? addr;
  final String? avatar;

  UserWriteModle({
    required this.username,
    required this.password,
    required this.nickname,
    this.email,
    this.phone,
    this.addr,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'nickName': nickname,
      'email': email,
      'phone': phone,
      'addr': addr,
      'avatar': avatar,
    };
  }
}
