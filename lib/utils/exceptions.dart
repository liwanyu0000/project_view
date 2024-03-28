import 'package:get/get.dart';

class HttpServiceException implements Exception {
  final Response response;

  HttpServiceException(this.response);

  @override
  String toString() {
    if (response.isOk) return 'Parsing failed'.tr;

    return (response.statusText != null && response.statusText!.isNotEmpty)
        ? response.statusText!
        : 'HttpServiceException: $response.statusCode';
  }
}
