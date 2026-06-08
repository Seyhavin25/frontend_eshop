import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../login/views/login_view.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {

  const SignupView({super.key});
  @override

  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: controller.formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Center(
                child: Text("Sign up to enjoys our services", style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
              SizedBox(height: 20),

              Obx(

                  () {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                        if(controller.photo!.value.path != "")
                          CircleAvatar(
                        backgroundImage: FileImage(controller.photo!.value),
                        radius: 50,
                      ),
                      if(controller.photo!.value.path == "")
                        CircleAvatar(
                        backgroundImage: NetworkImage("https://i.pinimg.com/736x/82/47/0b/82470b4ed44c3edacfcd4201e2297050.jpg"),
                        radius: 50,
                      ),


                      IconButton(onPressed: (){
                        controller.pickImage();
                      }, icon: Icon(Icons.camera_alt)),
                    ],
                  ),
                ],

              );
            }
          ),
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(

                  hintText: "Username",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value){
                  if(value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value){
                  if(value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if(!GetUtils.isEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              Obx(() => TextFormField(
                controller: controller.passwordController,
                obscureText: controller.isObscure.value,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    onPressed: controller.toggleObscure,
                    icon: Icon(
                      controller.isObscure.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              )),
              Obx(() => TextFormField(
                controller: controller.passwordConfirmationController,
                obscureText: controller.isObscure.value,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  prefixIcon: const Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }

                  if (value != controller.passwordController.text) {
                    return 'Passwords do not match';
                  }

                  return null; // validation passed
                },
              )),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: (){
                    controller.register();

                  }, child: Text('Sign up'))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children :[
                  Text('Already have an account?'),
                  TextButton(onPressed: (){
                    Get.back();
                  }, child: const Text('Login')),
                ],
              ),
          
          
              Spacer(),
          
          
          
            ],
          
          ),
        ),
      ),


    );
  }
}
