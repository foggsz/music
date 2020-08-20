import 'package:dio/dio.dart';

class HTTP {
  static String baseUrl = 'http://127.0.0.1:4000/';
  // static const  APIKEY = '0df993c66c0c636e29ecbb5344252a4a';
  static final HTTP _http = HTTP._internal();
  static const String GET = 'get';
  static const String POST = 'post';

  // static const Map<dynamic,dynamic>  _map={};
  Dio dio;

  factory HTTP() {
    return _http;
  }

  HTTP._internal() {
    this._initDio();
  }

  // 初始化dio
  void _initDio() {
    final BaseOptions baseOptions = BaseOptions(
      baseUrl: HTTP.baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 5000,
    );
    dio = Dio(baseOptions);
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      // options.queryParameters.addAll({'apikey': APIKEY });
      return options;
    }, onResponse: (Response res) {
      return res.data;
    }, onError: (DioError e) {
      return e;
    }));
  }

  // get
  get(String url, {data, Options options}) async {
    return this._requestHttp(url, data, GET, options);
  }

  // post
  post(String url, {data, Options options}) async {
    return this._requestHttp(url, data, POST, options);
  }

  _requestHttp(String url, data, String method, [Options options]) async {
    try {
      Response res;
      switch (method) {
        case POST:
          // url 增加时间戳强制刷新
          url = url + DateTime.now().millisecondsSinceEpoch.toString();
          res = await dio.post(url, data: data, options: options);
          break;
        case GET:
          res = await dio.get(url, queryParameters: data);
          break;
      }

      if (res.data['code'] == 200) {
        return res.data;
      }
      throw new DioError(error: '接口发生错误');
    } on DioError catch (e) {
      throw e;
    }
  }
}

final HTTP http = HTTP();
