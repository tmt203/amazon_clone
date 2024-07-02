import 'dart:convert';

import 'package:amazon_clone/constants/error_handler.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeService {
  Future<List<Product>> fetchProductsByCategory({required BuildContext context, required String category}) async {
    // Get user's token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');

    // HTTP request to fetch products
    http.Response res = await http.get(
      Uri.parse('$uri/api/products?category=$category'),
      headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'},
    );

    List<Product> products = [];

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () {
        for (int i = 0; i < jsonDecode(res.body)['data'].length; i++) {
          Product product = Product.fromMap(jsonDecode(res.body)['data'][i]);
          products.add(product);
        }
      },
    );

    return products;
  }

  Future<Product?> fetchDealOfDay({required BuildContext context}) async {
    Product? product;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');

    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/products/deal-of-day"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          product = Product.fromMap(jsonDecode(response.body)['data']);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    return product;
  }
}
