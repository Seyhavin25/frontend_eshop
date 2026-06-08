import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../signup/views/signup_view.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final _formkey= GlobalKey<FormState>();
  final emailController = TextEditingController(text: "wyman-abigail@mayer.info");
  final passwordController = TextEditingController(text: "123123123");
   LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Center(
                child: Text("Login to enjoys our services", style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: emailController,
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
              TextFormField(
                controller: passwordController,

                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.key),
                ),
                validator:(value){
                  if(value ==null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: (){
                    if(_formkey.currentState!.validate()){
                      final email = emailController.text;
                      final password = passwordController.text;
                      controller.login(email: email, password: password);



                    }
                  }, child: Text('Login'))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children :[
                  Text('don\'t have an account?'),
                  TextButton(onPressed: (){
                    Get.toNamed(Routes.SIGNUP);
                  }, child: Text('Sign up')),
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
