import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:amazon_clone/commons/widgets/custom_button.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/services/admin_service.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final AdminService adminService = AdminService();
  final _addProductFormKey = GlobalKey<FormState>();

  String category = 'Điện thoại';
  List<String> productCategories = ['Điện thoại', 'Yếu phẩm', 'Thiết bị', 'Sách', 'Thời trang'];
  List<File> images = [];

  void selectImages() async {
    images = await pickImages();
    setState(() {});
  }

  void addProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      adminService.addProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        quantity: int.parse(quantityController.text),
        price: double.parse(priceController.text),
        category: category,
        images: images,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: const Text(
            'Thêm sản phẩm',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Column(
              children: [
                images.isEmpty
                    ? GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.folder_open),
                                const SizedBox(height: 15),
                                Text(
                                  'Chọn ảnh sản phẩm',
                                  style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : CarouselSlider(
                        items: images
                            .map(
                              (File file) => Image.file(file),
                            )
                            .toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: productNameController,
                  decoration: const InputDecoration(hintText: 'Tên sản phẩm'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: productNameController,
                  decoration: const InputDecoration(hintText: 'Mô tả'),
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: productNameController,
                  decoration: const InputDecoration(hintText: 'Giá'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập giá';
                    } else {
                      try {
                        int price = int.parse(value);
                        if (price <= 0) {
                          return 'Không được nhỏ hơn 0';
                        }
                      } catch (e) {
                        return 'Vui lòng nhập giá trị hợp lệ';
                      }
                    }
                    return null; // Return null if validation succeeds
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: productNameController,
                  decoration: const InputDecoration(hintText: 'Số lượng'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập số lượng';
                    } else {
                      try {
                        int price = int.parse(value);
                        if (price <= 0) {
                          return 'Số lượng phải lớn hơn 0';
                        }
                      } catch (e) {
                        return 'Vui lòng nhập giá trị hợp lệ';
                      }
                    }
                    return null; // Return null if validation succeeds
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton(
                    value: category,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: productCategories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (value) => setState(() {
                      category = value!;
                    }),
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(text: 'Hoàn tất', onTap: addProduct),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
