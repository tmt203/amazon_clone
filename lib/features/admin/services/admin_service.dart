import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/error_handler.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/providers/admin/product_provider.dart';

class AdminService {
  // add product
  void addProduct({
    required BuildContext context,
    required String name,
    required String description,
    required int quantity,
    required double price,
    required String category,
    required List<File> images,
  }) async {
    try {
      // Connect to cloudinary server
      final cloudinary = CloudinaryPublic('dn80f9znp', 'prdnckxs');
      List<String> imageUrls = [];

      // Add images to cloudinary and get their url to save
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));
        imageUrls.add(res.secureUrl);
      }

      // Create new product
      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      // Update products STATE in admin
      Provider.of<ProductProvider>(context, listen: false).addProduct(product);

      // Retrieve the user's token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.get('x-auth-token');

      // POST request to save product to DB
      http.Response res = await http.post(
        Uri.parse('$uri/api/products'),
        body: product.toJson(),
        headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'},
      );

      // Handle API response
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Thêm sản phẩm thành công');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  // get all products
  Future<List<Product>> getAllProducts({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');
    List<Product> products = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products'),
        headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'},
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body)['data'].length; i++) {
            products.add(Product.fromJson(jsonEncode(jsonDecode(res.body)['data'][i])));
          }
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
    return products;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/products/${product.id}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'},
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  // fetch all orders
  Future<List<Order>> fetchAllOrders({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');
    List<Order> orders = [];

    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/orders"),
        headers: {
          'Content-Type': 'Application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(response.body)['data'].length; i++) {
            orders.add(Order.fromMap(jsonDecode(response.body)['data'][i]));
          }
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    return orders;
  }

  // analytics
  Future<Map<String, dynamic>> getAnalytics({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');
    List<Sales> sales = [];
    num totalEarnings = 0;

    try {
      http.Response response = await http.get(Uri.parse("$uri/api/orders/analytics"), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            print(jsonDecode(response.body)['data']);
            final data = jsonDecode(response.body)['data'];
            totalEarnings = data['totalEarnings'];
            sales = [
              Sales(label: 'Điện thoại', earning: data['mobilesEarnings']),
              Sales(label: 'Yếu phẩm', earning: data['essentialsEarnings']),
              Sales(label: 'Thiết bị', earning: data['deviceEarnings']),
              Sales(label: 'Sách', earning: data['booksEearnings']),
              Sales(label: 'Thời trang', earning: data['fashionEarnings']),
            ];
            sales.sort((saleA, saleB) => saleB.earning.compareTo(saleA.earning));
          });
    } catch (e) {
      debugPrint(e.toString());
    }

    return {
      'sales': sales,
      'totalEarnings': totalEarnings,
    };
  }

  // log out
  void logOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('x-auth-token', '');
      Navigator.pushNamedAndRemoveUntil(context, AuthScreen.routeName, (route) => false);
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }
}
