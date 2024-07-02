import 'dart:convert';

import 'package:amazon_clone/constants/error_handler.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductDetailService {
  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');

    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/products/rate-product'),
        headers: {'Content-Type': 'application/json; charset=UTF-8', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'productId': product.id,
          'rating': rating,
        }),
      );

      httpErrorHandle(response: response, context: context, onSuccess: () {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');

    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/users/add-to-cart"),
        body: jsonEncode({
          'productId': product.id,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
          User user = userProvider.user!.copyWith(cart: jsonDecode(response.body)['data']['cart']);
          userProvider.setUserFromModel(user);
          showSnackBar(context, jsonDecode(response.body)['message']);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
