// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:audio_probe/Custom/slide_right_route.dart';
import 'package:audio_probe/Utils/connectionstatus.dart';
import 'package:audio_probe/Views/login/loginscreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Navigation/nav.dart';
import 'log_interceptor.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;
  final NavigationService navigationService;

  late Dio dio;
  late String token = "";
  DioClient(
    this.baseUrl,
    Dio? dioC, {
    required this.loggingInterceptor,
    required this.sharedPreferences,
    required this.navigationService,
  }) {
    token = sharedPreferences.getString('token') ?? '';
    dio = dioC ?? Dio();
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 3)
      ..options.receiveTimeout = const Duration(seconds: 3)
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include the Bearer prefix here
      };
    dio.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      if (e is DioError) {
        try {
          if (e.response!.statusCode == 401) {
            var context = NavigationService.navigatorKey.currentState!.context;
            //Navigator.pushReplacement(context, SlideRightRoute(page: const LogoutScreen()));
          }
        } catch (e) {
          rethrow;
        }
      }
      rethrow;
    }
  }

  Future<Response> patch(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      if (e is DioError) {
        try {
          if (e.response!.statusCode == 401) {
            var context = NavigationService.navigatorKey.currentState!.context;
            //Navigator.pushReplacement(context, SlideRightRoute(page: const LogoutScreen()));
          }
        } catch (e) {
          rethrow;
        }
      }
      rethrow;
    }
  }
}
