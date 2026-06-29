import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_product_controller.dart';

class SearchProductView extends GetView<SearchProductController> {
  final searchController = TextEditingController();
  final baseUrl = "http://192.168.1.26:8000/storage/";

  SearchProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Favorite'),
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
                      itemBuilder: (context, index) {
                        final product = controller.products[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: baseUrl + product.image!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          CircularProgressIndicator(value: downloadProgress.progress),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name ?? "",
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          product.description ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "\$${product.price ?? '0'}",
                                          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
