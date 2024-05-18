class MessageWriteModel {
  final String message;
  final String type;
  final int? to;
  const MessageWriteModel({
    required this.message,
    required this.type,
    this.to,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'type': type,
      'to': to,
    };
  }
}
