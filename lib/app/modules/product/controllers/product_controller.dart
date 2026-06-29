import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/cate_product.model.dart';
import '../../../data/providers/api_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../../services/storage_service.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductController extends GetxController {
  final _api = Get.find<APIProvider>();
  final _storage = Get.find<StorageService>();
  Rx<CateProduct> product = Rx(CateProduct());
  RxBool isLoading = RxBool(true);

  void logout() async {
    Get.defaultDialog(
      title: "Logout",
      content: const Text("Are you sure you want to logout?"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                try {
                  final token = await AuthService.getToken();
                  if (token != null) {
                    await _api.logout(token);
                  }
                  Get.offAllNamed(Routes.LOGIN);
                } catch (e) {
                  Get.back();
                  Get.snackbar("Error", "Logout failed: $e");
                }
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("No"),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void onInit() {
    fetchProduct();
    super.onInit();
  }

  void fetchProduct() async {
    try {
      final response = await _api.getProduct();

      if (response.statusCode == 200) {
        product(CateProduct.fromJson(response.data));
        print("product ${product.value}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch product: $e");
    } finally {
      isLoading(false);
    }
  }



  void addProductToCart(int proId) async {
    print("TAPPED - proId: $proId");
    try {
      isLoading(true);
      print("Calling API...");
      final response = await _api.addToCard(qty: 1, proId: proId);
      print("Got response: ${response.statusCode}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Product added to cart",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        // Refresh CartController if it exists
        if (Get.isRegistered<CartController>()) {
          Get.find<CartController>().fetchProduct();
        }
        return;
      }
    } catch (e) {
      print("CAUGHT ERROR: $e");
      Get.snackbar("Error", "Failed to add product: $e");
    } finally {
      isLoading(false);
    }
  }
}
