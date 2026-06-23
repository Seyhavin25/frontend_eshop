import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eshop/app/services/auth_service.dart';

import '../../services/storage_service.dart';
import '../models/Address/req_address.dart'; // Add this import

class APIProvider {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.215:8000',
      contentType: 'application/json',
      responseType: ResponseType.json,
      validateStatus: (status) => status! < 500,
    ),
  );

  // Add constructor to setup interceptors
  APIProvider() {
    _setupInterceptors();
  }

  // Setup interceptors to automatically add token to all requests
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Automatically add token to all requests
          String? token = await AuthService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthenticated errors
          if (error.response?.statusCode == 401) {
            await AuthService.removeToken();
            // Optional: Navigate to login screen
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> login({
    required String gmail,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        "/api/login",
        data: {"email": gmail, "password": password},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );

      // Save token after successful login
      if (response.statusCode == 200 && response.data['token'] != null) {
        await AuthService.saveToken(response.data['token']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> logout(String token) async {
    try {
      final response = await _dio.post(
        "/api/logout",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      // Remove token after successful logout
      if (response.statusCode == 200) {
        await AuthService.removeToken();
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> signup({
    required String email,
    required String password,
    required String name,
    required String password_confirmation,
    File? image,
  }) async {
    try {
      var _formData = FormData.fromMap({
        "email": email,
        "password": password,
        "password_confirmation": password_confirmation,
        "name": name,
        "avatar": image != null ? await MultipartFile.fromFile(image.path) : null,
      });

      final response = await _dio.post(
        "/api/register",
        data: _formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data", // Changed for file upload
            "Accept": "application/json",
          },
        ),
      );

      // Save token after successful signup (if your API returns a token)
      if (response.statusCode == 200 && response.data['token'] != null) {
        await AuthService.saveToken(response.data['token']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getProduct() async {
    try {
      // Token is automatically added by the interceptor
      return await _dio.get(
        "/api/products",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> getProductByCate(int cateId) async {
    try {
      // Token is automatically added by the interceptor
      return await _dio.get(
        "/api/products/$cateId",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> searchProduct(String keyword) async {
    try {
      // Token is automatically added by the interceptor
      return await _dio.get(
        "/api/products/search",
        queryParameters: {
          "search": keyword
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAddress() async {
    try {
      // Token is automatically added by the interceptor
      return await _dio.get(
        "/api/address",

        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> addAddress(ReqAddress address) async {
    try {
      return await _dio.post(
        "/api/address",
        data: address.toJson(),

        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> addToCard({required int qty, required int pro_id}) async {
     try {
       return await _dio.post(
         "/api/address",
         data: {
           "quantity": 2,
           "product_id": 1
         },

         options: Options(
           headers: {
             "Content-Type": "application/json",
             "Accept": "application/json",
           },
         ),
       );
     } catch (e) {
       rethrow;
     }
   }
}