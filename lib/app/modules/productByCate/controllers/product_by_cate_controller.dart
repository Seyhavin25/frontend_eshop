import 'package:eshop/app/data/providers/api_provider.dart';
import 'package:get/get.dart';

import '../../../data/models/list_product_by_cate.dart';

class ProductByCateController extends GetxController {
  //TODO: Implement ProductByCateController

 final _api = Get.find<APIProvider>();
 RxList<ListProductByCate> products = RxList([]);
 RxBool isLoading = true.obs;
 @override
  void onInit() {
   fetchProductByCate();
    // TODO: implement onInit
    super.onInit();
  }
 void fetchProductByCate() async {

   try{
     final cateId = Get.arguments;
     if(cateId == null)
       return;

    final response = await _api.getProductByCate(cateId);
    if (response.statusCode == 200) {
      final data = response.data as List;
     products.value = data.map((pro) => ListProductByCate.fromJson(pro)).toList();
    } else {
      Get.snackbar("Error", "Failed to fetch products");



    }





   }catch(e){

      Get.snackbar("Error", e.toString());


   }finally{
     isLoading(false);
   }

 }

}
