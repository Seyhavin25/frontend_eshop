import 'dart:io';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/providers/api_provider.dart';
import '../../../routes/app_pages.dart';

class SignupController extends GetxController {
  final _api = Get.find<APIProvider>();
  final formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final faker = Faker();

  Rx<File>? photo = Rx(File(""));
  final picker = ImagePicker();
  RxBool isObscure = true.obs;

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  void pickImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      photo!(File(file.path));
    }
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    passwordController.text = "123123123";
    passwordConfirmationController.text = "123123123";
    emailController.text = faker.internet.email();
    nameController.text =
        "${faker.person.firstName()} ${faker.person.lastName()}";
    // TODO: implement onReady
    super.onReady();
  }

  void register() async {
    print("created");

    if (formkey.currentState!.validate()) {
      try {
        final name = nameController.text;
        final email = emailController.text;
        final password = passwordController.text;
        final password_confirmation = passwordConfirmationController.text;

        final image = photo!.value.path.isNotEmpty ? photo!.value : null;

        final response = await _api.signup(
          email: email,
          password: password,
          name: name,
          image: image,
          password_confirmation: password_confirmation,
        );
        if (response.statusCode == 200) {
          Get.snackbar("Message", "Register successfully");
          Get.offAllNamed(Routes.LOGIN);
        } else {
          Get.snackbar("Error", "Register failed: ${response.data['message'] ?? 'Unknown error'}");
        }
        print("${response.data}");
        print("${response.statusCode}");
      } catch (e) {
        Get.defaultDialog(title: "Error", content: Text(("$e")));
      }
    }
  }
}
