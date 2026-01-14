// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:actitrack/src/services/cache/prefs.dart';
// import 'package:actitrack/src/utils/logging/logger.dart';

// class AppHttpClient {
//   static const String baseUrl = 'https://actitrack.nuancestraiteur.com/api';
//   final Dio _dio;

//   AppHttpClient._internal(this._dio);

//   static final AppHttpClient _instance = AppHttpClient._internal(
//     Dio(
//       BaseOptions(
//         baseUrl: baseUrl,
//         connectTimeout: const Duration(milliseconds: 5000),
//         receiveTimeout: const Duration(milliseconds: 3000),
//         // headers: {
//         //   'Content-Type': 'application/json',
//         // },
//       ),
//     ),
//   );

//   factory AppHttpClient() {
//     _instance._initializeInterceptors();
//     return _instance;
//   }

//   void _initializeInterceptors() {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           String? token = Prefs.getUserAccessToken();
//           // if (token != null) options.headers['Authorization'] = 'Bearer $token';
//           MyLogger.info('REQUEST[${options.method}] => URI: ${options.uri}');
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           MyLogger.info('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
//           return handler.next(response);
//         },
//         onError: (DioException e, handler) {
//           MyLogger.error('ERROR[${e.response?.statusCode}] => URI: ${e.requestOptions.uri} HEADERS: ${e.requestOptions.headers} DATA: ${e.requestOptions.data}');
//           return handler.next(e);
//         },
//       ),
//     );
//   }

//   Future<Response> getRequest(String endpoint, {Map<String, dynamic>? queryParameters}) async {
//     try {
//       final response = await _dio.get(endpoint, queryParameters: queryParameters);
//       return response;
//     } on DioException catch (e) {
//       _handleError(e);
//       rethrow;
//     }
//   }

//   Future<Response> postRequest(String endpoint, {Map<String, dynamic>? data}) async {
//     try {
//       final response = await _dio.post(endpoint, data: jsonEncode(data));
//       return response;
//     } on DioException catch (e) {
//       _handleError(e);
//       rethrow;
//     }
//   }

//   Future<Response> putRequest(String endpoint, {Map<String, dynamic>? data}) async {
//     try {
//       final response = await _dio.put(endpoint, data: jsonEncode(data));
//       return response;
//     } on DioException catch (e) {
//       _handleError(e);
//       rethrow;
//     }
//   }

//   Future<Response> deleteRequest(String endpoint, {Map<String, dynamic>? data}) async {
//     try {
//       final response = await _dio.delete(endpoint, data: jsonEncode(data));
//       return response;
//     } on DioException catch (e) {
//       _handleError(e);
//       rethrow;
//     }
//   }

//   void _handleError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.sendTimeout:
//       case DioExceptionType.receiveTimeout:
//         MyLogger.error('Connection Timeout Exception');
//         break;
//       case DioExceptionType.badResponse:
//         MyLogger.error('Received invalid status code: ${error.response?.statusCode}');
//         break;
//       case DioExceptionType.cancel:
//         MyLogger.error('Request to API server was cancelled');
//         break;
//       case DioExceptionType.badCertificate:
//         MyLogger.error('Bad Certificate: $error');
//         break;
//       case DioExceptionType.connectionError:
//         MyLogger.error('Connection error: $error');
//         break;
//       case DioExceptionType.unknown:
//         MyLogger.error('Unexpected error: $error');
//         break;
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:actitrack/src/services/cache/prefs.dart';
import 'package:actitrack/src/utils/logging/logger.dart';

class AppHttpClient {
  static const String baseUrl = 'https://actitrack.nuancestraiteur.com/api';
  final http.Client _client;

  AppHttpClient._internal(this._client);

  static final AppHttpClient _instance = AppHttpClient._internal(http.Client());

  factory AppHttpClient() {
    return _instance;
  }

  Future<http.Response> getRequest(String endpoint) async {
    try {
      String url = "$baseUrl$endpoint";
      MyLogger.info('GET REQUEST => URI: $url');
      String? token = Prefs.getUserAccessToken();

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      MyLogger.info("HEADE: $headers");
      final response = await _client.get(Uri.parse(url), headers: headers);

      _logResponse(response);
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<http.Response> postRequest(String endpoint,
      {Map<String, dynamic>? data}) async {
    try {
      String url = '$baseUrl$endpoint';
      String? token = Prefs.getUserAccessToken();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      MyLogger.info('POST REQUEST => URI: $url');
      final response = await _client.post(Uri.parse(url),
          headers: headers, body: jsonEncode(data));
      _logResponse(response);
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<http.Response> putRequest(String endpoint,
      {Map<String, dynamic>? data}) async {
    try {
      String url = '$baseUrl$endpoint';
      String? token = Prefs.getUserAccessToken();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      MyLogger.info('PUT REQUEST => URI: $url');
      final response = await _client.put(Uri.parse(url),
          headers: headers, body: jsonEncode(data));
      _logResponse(response);
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<http.Response> deleteRequest(String endpoint,
      {Map<String, dynamic>? data}) async {
    try {
      String url = '$baseUrl$endpoint';
      String? token = Prefs.getUserAccessToken();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      MyLogger.info('DELETE REQUEST => URI: $url');
      final response = await _client.delete(Uri.parse(url),
          headers: headers, body: jsonEncode(data));
      _logResponse(response);
      return response;
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _logResponse(http.Response response) {
    MyLogger.info('RESPONSE[${response.statusCode}] => BODY: ${response.body}');
  }

  void _handleError(dynamic error) {
    if (error is http.ClientException) {
      MyLogger.error('Client Exception: $error');
    } else {
      MyLogger.error('Unexpected error: $error');
    }
  }
}
