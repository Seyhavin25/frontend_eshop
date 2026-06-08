import 'package:eshop/app/data/providers/api_provider.dart';
import 'package:eshop/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class DependencyInjections {
  static Future<void> init() async {
    Get.put(StorageService(), permanent: true);

    Get.put(APIProvider(), permanent: true);
  }
}
