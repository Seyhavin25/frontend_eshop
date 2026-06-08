import 'package:get/get.dart';

import '../../../data/models/search_product.dart';
import '../../../data/providers/api_provider.dart';

class SearchProductController extends GetxController {
  final _api = Get.find<APIProvider>();
  RxList<SearchProductResult> products = RxList([]);
  RxBool isLoading = RxBool(false);


  void searchProduct(String keyword) async {
    try {
      isLoading.value = true;
      final response = await _api.searchProduct(keyword);
      if (response.statusCode == 200) {
        final data = response.data as List;
        products.value = data
            .expand((item) => item is List ? item : [item])
            .map((pro) => SearchProductResult.fromJson(pro as Map<String, dynamic>))
            .toList();
        return;
      }
      throw Exception(response.statusCode);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }finally{
      isLoading.value = false;
    }
  }
}
