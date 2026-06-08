import 'package:eshop/app/data/models/Address/req_address.dart';
import 'package:eshop/app/data/providers/api_provider.dart';
import 'package:get/get.dart';

class AddAddressController extends GetxController {
  final _api = Get.find<APIProvider>();
  final RxBool isLoading = false.obs; // ← Add this line


  void addAddress(ReqAddress address)async{
    try{
      final response = await _api.addAddress(address);
      if(response.statusCode == 200){
        Get.snackbar("Success", "Address added");
        return;
      }
      throw Exception(response.statusMessage);

    }catch(e){
      Get.snackbar("Error", e.toString());
    }
  }



}
