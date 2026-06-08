import 'package:eshop/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../data/providers/api_provider.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final _api = Get.find<APIProvider>();

  void login({required String email, required String password}) async {
    try {
      final res = await _api.login(gmail: email, password: password);
      print("res ${res.data}");
      print("res ${res.statusCode}");
      
      if (res.statusCode == 200) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.defaultDialog(
          title: "Error",
          content: Text(res.data['message'] ?? "Login failed"),
        );
      }
    } catch (e) {
      if (e is DioException) {
        Get.defaultDialog(
          title: "Error",
          content: Text(
            e.response?.data['message'] ?? "Connection error",
          ),
        );
      } else {
        Get.defaultDialog(
          title: "Error",
          content: Text(e.toString()),
        );
      }
    }
  }
}
