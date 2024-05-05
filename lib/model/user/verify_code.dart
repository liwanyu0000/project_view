import 'dart:convert';
import 'dart:typed_data';

class VerifyCodeModel {
  final String codeToken;
  final String codeImg;

  const VerifyCodeModel({required this.codeImg, required this.codeToken});

  Uint8List get img => base64Decode(codeImg);

  factory VerifyCodeModel.fromJson(Map<String, dynamic> json) =>
      VerifyCodeModel(
        codeImg: json['codeImg'],
        codeToken: json['codeToken'],
      );
}
