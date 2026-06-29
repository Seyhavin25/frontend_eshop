import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eshop/app/services/auth_service.dart';

import '../models/Address/req_address.dart';

class APIProvider {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.26:8000',
      contentType: 'application/json',
      responseType: ResponseType.json,
      validateStatus: (status) => status! < 500,
    ),
  );

  APIProvider() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await AuthService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await AuthService.removeToken();
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
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
          },
        ),
      );

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
  Future<Response> addToCard({required int qty, required int proId}) async {
     try {
       return await _dio.post(
         "/api/cart",
         data: {
           "quantity": qty,
           "product_id": proId
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
  Future<Response> getCart() async {
    try {
      return await _dio.get(
        "/api/cart/view",
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
  Future<Response> updateCartItemQuantity({required int itemId, required int quantity}) async {
    return await _dio.patch(
      "/api/cart/item/$itemId",
      data: {"quantity": quantity},
    );
  }
}