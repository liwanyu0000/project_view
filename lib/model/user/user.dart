class UserModel {
  final int id;
  final String username;
  final String nickname;
  final String? email;
  final String? phone;
  final String? addr;
  final String? avatar;
  final String role;
  final String permission;
  final DateTime createTime;
  final DateTime updateTime;
  UserModel({
    required this.id,
    required this.username,
    required this.nickname,
    required this.email,
    required this.phone,
    required this.addr,
    required this.role,
    required this.avatar,
    required this.permission,
    required this.createTime,
    required this.updateTime,
  });

  /// Check if the user is an admin
  bool get isAdmin => role == 'Admin';

  /// Check if the user has the permission to login
  bool get canLogin => permission.contains('login');

  /// Check if the user has the permission to create
  bool get canCreate => permission.contains('create');

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['userName'],
      nickname: json['nickName'],
      email: json['email'],
      phone: json['phone'],
      addr: json['addr'],
      role: json['userRole'],
      avatar: json['avatar'],
      permission: json['userPermission'],
      createTime: DateTime.parse(json['createTime']),
      updateTime: DateTime.parse(json['updateTime']),
    );
  }
}
