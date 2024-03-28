/// http请求服务，非侵入透明方式完成网络日志记录并对返回数据进行统一预处理
///
/// request.decoder只对body数据进行解码(_http_request_io.dart#37 send)，并且会阻止异常抛出，异常时直接返回bodyString(body_decoder.dart)
/// 此外，get/post等操作中的类型参数，也是对应body，具体业务场景中可能遇到2个问题
///  1. http异常或请求失败
///  2. 业务异常
/// 共分为4种情况(http.dart#196 _performRequest对未授权异常的处理逻辑)
///  1. http异常
///       header: null, body: null, statusCode: null, statusText: $err
///  2. http错误（比如404，服务器内部错误）
///       header: notNull, body: maybeNull(但不可解析), statusCode: $code, statusText: $statusText || ''
///  3. 业务层错误
///       header: notNull, body: _ResponseModel(code < 0), statusCode: 200, statusText: ''
///  4. 正常
///       header: notNull, body: _ResponseModel(code == 0), statusCode: 200, statusText: ''
/// >> 参考response.dart中的代码，Response中有两个getter，isOk和hasError，其判断statusCode是否在200-299之间
///
/// ! 按照统一错误归口到statusCode，错误详情放到statusText中，body中恒为业务数据的原则
/// * 设计如下
///  1. http的异常和错误不做任何处理
///  2. 业务层按如下方式映射
///    错误：_ResonseModel<code, message, data> => <statusCode, statusText, body>
///    正常：_ResonseModel<message, data> => <statusText, body>
///  后续Repository层通过isOK&hasError判断是否成功，成功情况下直接解析body，失败通过statusCode判断错误类型分别处理

import 'dart:convert';

import 'package:get/get.dart';

import '../config/constants.dart';
import '../utils/exceptions.dart';
import 'logger.dart';

class _ResponseModel<T> {
  final int code;
  final String message;
  final T? data;

  const _ResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });
  factory _ResponseModel.fromJson(Map<String, dynamic> json) {
    return _ResponseModel(
      code: json['code'],
      message: json['message'],
      data: json['data'],
    );
  }
}

class HttpService extends GetxService {
  static HttpService get to => Get.find();

  final LoggerService logger;
  final GetConnect _http;
  String? _token;

  HttpService(this.logger, {String? userAgent, String? baseUrl})
      : _http = GetConnect(
            sendUserAgent: userAgent != null,
            userAgent: userAgent ?? kProductName) {
    _http.baseUrl = baseUrl;
  }

  @override
  void onInit() {
    _http.httpClient.defaultDecoder = (val) {
      if (val is Map<String, dynamic> &&
          val['code'] is int &&
          val['message'] is String) {
        return _ResponseModel.fromJson(val);
      }
      return val;
    };

    // 授权修改器只在请求返回需要授权时(401)通过添加授权头重新请求
    // httpClient.addAuthenticator<dynamic>((request) {
    //   return request;
    // });

    _http.httpClient.addRequestModifier<dynamic>((request) {
      if (_token != null) request.headers['token'] = _token!;
      return request;
    });

    // GetModifier::modifyResponse有BUG，不是链式处理，因此这里没办法把日志处理器单独抽象出来做成一个单独的Modifier，只能放到一起处理
    _http.httpClient.addResponseModifier((request, response) async {
      if (response.body is _ResponseModel) {
        final model = response.body as _ResponseModel;
        response = Response(
          request: response.request,
          statusCode: model.code == 0 ? response.statusCode : model.code,
          statusText: model.message,
          body: model.data,
          headers: response.headers,
          bodyBytes: response.bodyBytes,
          bodyString: response.bodyString,
        );
      }

      // 日志记录
      final statusText = !response.isOk && response.statusText != null
          ? response.statusText!
          : '';
      logger.log(
        response.isOk ? Level.info : Level.error,
        '${request.method.toUpperCase()} ${request.url} ${response.statusCode} $statusText',
        tag: [runtimeType],
      );
      final requestBody = (await request.bodyBytes.toList())
          .expand((element) => element)
          .toList();
      if (requestBody.isNotEmpty) logger.t(utf8.decode(requestBody), tag: '→');
      if (!_isResponseBodyEmpty(response.body)) {
        logger.t(response.body, tag: '←');
      } else if (!_isResponseBodyEmpty(response.bodyString)) {
        logger.t(response.bodyString, tag: '←');
      }

      return response;
    });

    super.onInit();
  }

  bool _isResponseBodyEmpty(dynamic body) {
    if (body == null) return true;
    if (body is String && body.isEmpty) return true;
    return false;
  }

  T _hookResponseWithException<T>(Response response, Decoder<T>? decoder) {
    if (response.hasError) throw HttpServiceException(response);
    try {
      return decoder == null ? response.body : decoder(response.body);
    } catch (e) {
      logger.e('Parsing failed: $e', tag: [runtimeType]);
      throw HttpServiceException(response);
    }
  }

  Future<T> get<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    return _hookResponseWithException<T>(
      await _http.get(
        url,
        headers: headers,
        contentType: contentType,
        query: query,
      ),
      decoder,
    );
  }

  Future<T> post<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Progress? uploadProgress,
    Decoder<T>? decoder,
  }) async {
    return _hookResponseWithException(
      await _http.post(
        url,
        body,
        headers: headers,
        contentType: contentType,
        query: query,
        uploadProgress: uploadProgress,
      ),
      decoder,
    );
  }

  set token(String? newToken) {
    logger.i('Token modified: $_token  -> $newToken', tag: [runtimeType]);
    _token = newToken;
  }
}
