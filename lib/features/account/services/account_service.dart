import 'dart:convert';

import 'package:amazon_clone/constants/error_handler.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AccountService {
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

  Future<List<Order>> fetchMyOrders({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orders = [];
    try {
      http.Response response = await http.get(Uri.parse('$uri/api/orders?user=${userProvider.user!.id}'), headers: {
        'Content-Type': 'Application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

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
}
