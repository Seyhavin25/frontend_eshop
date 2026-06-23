import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_product_controller.dart';

class SearchProductView extends GetView<SearchProductController> {
  final searchController = TextEditingController();
  final baseUrl = "http://192.168.1.215:8000/storage/";

  SearchProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SearchProductView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              onFieldSubmitted: (value){
                print("value: $value");
                controller.searchProduct(value);
              },
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
              ),

            ),
            Expanded(

              child: Obx(
                 () {
                   if(controller.isLoading.value)return Center(child: CircularProgressIndicator());
                  return ListView.builder(
                    itemCount: controller.products.length,
                    itemBuilder: (context,index){
                      final product = controller.products[index];
                      return ListTile(
                        title: Text(product.name ?? ""),
                        leading: CachedNetworkImage(
                          imageUrl: (baseUrl + product.image!),
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                         CircularProgressIndicator(value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      );
                    }

                  );
                }
              ),
            )
          ],



        ),
      ),

    );
  }
}
