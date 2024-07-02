import 'dart:convert';

import 'package:amazon_clone/constants/error_handler.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
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
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');

    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/users/remove-from-cart"),
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
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
