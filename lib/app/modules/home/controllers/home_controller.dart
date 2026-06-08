import 'package:eshop/app/modules/app_settings/bindings/app_settings_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../app_settings/views/app_settings_view.dart';
import '../../cart/bindings/cart_binding.dart';
import '../../cart/views/cart_view.dart';
import '../../product/bindings/product_binding.dart';
import '../../product/views/product_view.dart';
import '../../search_product/bindings/search_product_binding.dart';
import '../../search_product/views/search_product_view.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var selectedIndex = 0.obs;
  var lstRoutesName = [
    Routes.PRODUCT,
    Routes.SEARCH_PRODUCT,
    Routes.CART,
    Routes.APP_SETTINGS,
  ];



  void onPageChange(index){
     selectedIndex.value = index;
     Get.offAllNamed(lstRoutesName[index],id: 1 );

  }



Route? onGenerateRoute(RouteSettings settings) {
  if (settings.name == Routes.PRODUCT) {
    return GetPageRoute(
      settings: settings,
      page: () => ProductView(),
      binding: ProductBinding(),

    );
  }

    if (settings.name == Routes.SEARCH_PRODUCT) {
      return GetPageRoute(
        settings: settings,
        page: () => SearchProductView(),
        binding: SearchProductBinding(),

      );
}
  if (settings.name == Routes.CART) {
    return GetPageRoute(
      settings: settings,
      page: () => CartView(),
      binding: CartBinding(),

    );
  }
  if (settings.name == Routes.APP_SETTINGS) {
    return GetPageRoute(
      settings: settings,
      page: () => AppSettingsView(),
      binding: AppSettingsBinding(),

    );
  }



  // GetPage(
  //   name: _Paths.PRODUCT,
  //   page: () => const ProductView(),
  //   binding: ProductBinding(),
  // ),
  //
  // GetPage(
  //   name: _Paths.CART,
  //   page: () => const CartView(),
  //   binding: CartBinding(),
  // ),
  // GetPage(
  //   name: _Paths.SEARCH_PRODUCT,
  //   page: () => const SearchProductView(),
  //   binding: SearchProductBinding(),
  // ),
}

}
