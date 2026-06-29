import 'dart:convert';
import 'package:get/get.dart';

import '../../../data/models/cart_model.dart';
import '../../../data/providers/api_provider.dart';

class CartController extends GetxController {
  final _api = Get.find<APIProvider>();
  RxBool isLoading = true.obs;

  var cartItems = <CartItems>[].obs;
  var total = 0.0.obs;
  var subTotal = 0.0.obs;
  var shipping = 0.0.obs;

  final count = 0.obs;
  final cartCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProduct();
  }

  void fetchProduct() async {
    try {
      isLoading(true);
      final response = await _api.getCart();
      print("DEBUG: Cart API Status: ${response.statusCode}");
      print("DEBUG: Cart API Data Type: ${response.data.runtimeType}");
      print("DEBUG: Cart API Data: ${response.data}");

      if (response.statusCode == 200) {
        List<CartItems> lstItems = [];

        // Handle both List and Map response
        if (response.data is List) {
          final data = response.data as List;
          for (var cart in data) {
            if (cart['items'] is List) {
              final items = (cart['items'] as List)
                  .map((pro) => CartItems.fromJson(pro))
                  .toList();
              lstItems.addAll(items);
            }
          }
        } else if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          // Check for 'items' directly or nested in 'data'
          var itemsData = data['items'] ??
              (data['data'] != null ? data['data']['items'] : null);
          if (itemsData is List) {
            lstItems =
                itemsData.map((item) => CartItems.fromJson(item)).toList();
          } else if (data['cart_items'] is List) {
            // Some APIs might use 'cart_items' instead of 'items'
            lstItems = (data['cart_items'] as List)
                .map((item) => CartItems.fromJson(item))
                .toList();
          }
        }

        cartItems.assignAll(lstItems);
        cartCount.value = cartItems.length;

        print(
            "cartItems: ${jsonEncode(cartItems.map((e) => e.toJson()).toList())}");

        recalcTotals(); // ✅ FIXED — was double-multiplying price * quantity
        return;
      }

      throw response.data['message'] ?? "Unknown error";
    } catch (e) {
      print("ERROR FETCHING CART: $e");
      // Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // ✅ NEW: increment or decrement a cart item's quantity
  void incrementDecrementItem(CartItems item, bool increase) async {
    final currentQty = (item.quantity ?? 1).toInt();
    final newQty = increase ? currentQty + 1 : currentQty - 1;

    if (newQty < 1) return; // block going below 1; use delete to remove instead

    try {
      final response = await _api.updateCartItemQuantity(
        itemId: item.id!,
        quantity: newQty,
      );

      if (response.statusCode == 200) {
        item.quantity = newQty;
        item.price = newQty * (item.product?.price ?? 0); // recalc line total
        cartItems.refresh(); // triggers Obx rebuild

        recalcTotals();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update quantity: $e");
    }
  }

  // ✅ NEW: shared total calculation — no more double-multiplying price * quantity
  void recalcTotals() {
    total.value = cartItems.fold(
      0.0,
          (sum, item) => sum + (item.price ?? 0),
    );
    subTotal.value = total.value - shipping.value;
  }
}