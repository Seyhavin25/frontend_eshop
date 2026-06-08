import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/app_settings_controller.dart';

class AppSettingsView extends GetView<AppSettingsController> {
  const AppSettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppSettingsView'),
        centerTitle: true,
      ),
      body:  Center(
        child: Column(
          children: [

            ListTile(
              onTap: (){
                Get.toNamed(Routes.ADDRESS);
              },
              title: Text('Address'),

              leading: Icon(Icons.location_on),
              trailing: Icon(Icons.arrow_forward_ios),
            )
          ],
        ),

      ),
    );
  }
}
