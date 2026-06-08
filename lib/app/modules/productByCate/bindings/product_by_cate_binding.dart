import 'package:get/get.dart';

import '../controllers/product_by_cate_controller.dart';

class ProductByCateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductByCateController>(
      () => ProductByCateController(),
    );
  }
}
