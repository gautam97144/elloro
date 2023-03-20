import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elloro/services/api_endpoints.dart';

import 'api_response_model.dart';
import 'app_exption.dart';
import 'function.dart';

class ApiClient {
  final Dio dio = Dio(BaseOptions(
    baseUrl: EndPoints.baseUrl,
    connectTimeout: 50000,
    receiveTimeout: 50000,
  ));

  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    //Check Internet...

    bool internetStatus = await Functions.checkConnectivity();

    if (internetStatus) {
      try {
        final Response response = await dio.post(
          uri,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );

        // print("Post Method Response :-");

        ApiResponseModel responseData =
            await apiResponseModel(response.data, response.statusCode);

        return responseData;
      } on SocketException {
        throw NoInternetException(
            "Something went wrong with server connection, please check after some time");
      } on DioError catch (e) {
        throw e;
      }
    } else {
      return apiResponseModel({'message': '', 'status': 0, 'data': ''}, 1001);
    }
  }

  Future<ApiResponseModel> apiResponseModel(
      dynamic response, statusCode) async {
    ApiResponseModel apiResponseModel =
        ApiResponseModel.fromJson(response, statusCode);
    return apiResponseModel;
  }
}
