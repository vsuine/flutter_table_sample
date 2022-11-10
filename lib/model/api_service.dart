import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'generated/api_service.g.dart';

// api との接続と結果の取得を retrofit に任せる
@RestApi(baseUrl: '')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;
}
