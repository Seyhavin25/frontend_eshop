import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  final logoutController = TextEditingController();
  final baseUrl = "http://192.168.1.230:8000/storage/";

  ProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              controller.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
        title: const Text('ProductView'),
        centerTitle: true,
      ),
      body:



      Column(
        children: [

          Container(
            height: 200,
            width: double.infinity,
            child: Center(child: Text("Advertisment ")),


          ),


          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final product = controller.product.value;
              if (product.category == null || product.category!.isEmpty) {
                return const Center(child: Text("No Categories Found"));
              }

              return SizedBox(
                width: 120,
                child: ListView.builder(
                  itemCount: product.category!.length,
                  itemBuilder: (context, index) {
                    final cate = product.category![index];
                    return SizedBox(
                      width: 120,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Text(cate.name ?? "" , style: TextStyle(
                                     fontSize: 20,
                                   fontWeight: FontWeight.bold
                                 )),
                                TextButton(onPressed: (){
                                  Get.toNamed(Routes.PRODUCT_BY_CATE, arguments: cate.id);
                                }, child: Text("See all")),

                              ],
                            ),
                          ),

                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: (cate.products == null || cate.products!.isEmpty)
                                  ? 0
                                  : cate.products!.length,
                              itemBuilder: (context, index) {
                                final pro = cate.products![index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [

                                      Image.network(baseUrl + pro.image!,width: 100,),

                                      Text(pro.name ?? ""),
                                      Row(
                                        children: [
                                          Text("\$${pro.price}"),
                                          SizedBox(
                                              height: 32,
                                              width: 32,
                                              child: IconButton(onPressed: (){}, icon: Icon(Icons.add_shopping_cart)))

                                        ],
                                      ),
                                    ],

                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
