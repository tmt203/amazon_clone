import 'dart:convert';

import 'package:amazon_clone/constants/error_handler.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchService {
  Future<List<Product>> fetchSearchedProduct({
    required BuildContext context,
    required String searchQuery,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');
    List<Product> products = [];

    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/products/search/$searchQuery'),
        headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'},
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body)['data'];
          products = List<Product>.from(data.map((product) => Product.fromMap(product)));
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    return products;
  }
}
