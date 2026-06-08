import 'package:get/get.dart';

import '../../../../data/models/Address/address.model.dart';
import '../../../../data/providers/api_provider.dart';

class AddressController extends GetxController {
  final api = Get.find<APIProvider>();
  RxList<Address> lstAddress = <Address>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getAddress();
    super.onInit();
  }

  void getAddress() async {
    try {
      isLoading.value = true;
      final response = await api.getAddress();

      if (response.statusCode == 200) {
        final rawData = response.data;

        final List<dynamic> dataList = (rawData is Map && rawData.containsKey('address'))
            ? rawData['address']
            : (rawData is List ? rawData : []);

        lstAddress.value = dataList
            .map((item) => Address.fromJson(item as Map<String, dynamic>))
            .toList();
        return;
      }
      throw Exception(response.statusMessage);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}