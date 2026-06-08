import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.lstAddress.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.lstAddress.length,
          itemBuilder: (context, index) {
            final address = controller.lstAddress[index];
            return ListTile(
              leading: const Icon(Icons.home),
              title: Text(address.city ?? "Unknown"),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Get.toNamed(Routes.ADD_ADDRESS);
      }, child: Icon(Icons.add),),
    );
    
  }
}