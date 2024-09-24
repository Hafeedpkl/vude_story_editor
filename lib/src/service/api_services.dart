import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:vude_story_editor/src/core/constants.dart';

class ApiServices {
  Dio dio = Dio();
  Future<Response> getMethod(String path,
      {JSON? parameters, JSON? data}) async {
    final response = await dio
        .get(path, queryParameters: parameters, data: data)
        .onError((error, stackTrace) {
      throw Exception(error);
    });
    return response;
  }

  Future<Response> postMethod(String path,
      {JSON? parameters, JSON? data}) async {
    final response = await dio
        .post(path, queryParameters: parameters, data: data)
        .onError((error, stackTrace) {
      throw Exception(error);
    });
    return response;
  }
}

prettyLog(object) =>
    log(const JsonEncoder.withIndent(' ').convert(object), name: 'prettyLog');
