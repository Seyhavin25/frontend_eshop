import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  final baseUrl = "http://192.168.1.215:8000/storage/";

  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              controller.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: const Text('ProductView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[200],
            child: const Center(child: Text("Advertisment ")),
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
              return ListView.builder(
                itemCount: product.category!.length,
                itemBuilder: (context, index) {
                  final cate = product.category![index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                cate.name ?? "",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.PRODUCT_BY_CATE,
                                    arguments: cate.id);
                              },
                              child: const Text("See all"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 250, // Increased height to prevent vertical overflow
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: (cate.products == null ||
                                  cate.products!.isEmpty)
                              ? 0
                              : cate.products!.length,
                          itemBuilder: (context, index) {
                            final pro = cate.products![index];
                            return Container(
                              width: 140, // Fixed width for each product card
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      baseUrl + (pro.image ?? ""),
                                      width: 140,
                                      height: 140,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        print("--- IMAGE ERROR ---");
                                        print("URL: ${baseUrl + (pro.image ?? "")}");
                                        print("Error: $error");
                                        return Container(
                                          width: 140,
                                          height: 140,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image_not_supported, color: Colors.red),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    pro.name ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\$${pro.price}",
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 32,
                                        width: 32,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.add_shopping_cart,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
