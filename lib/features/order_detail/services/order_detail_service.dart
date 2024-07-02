import 'dart:convert';

import 'package:amazon_clone/constants/error_handler.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderDetailService {
  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');

    try {
      http.Response response = await http.patch(
        Uri.parse("$uri/api/orders/${order.id}"),
        headers: {
          'Content-Type': 'Application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );

      httpErrorHandle(response: response, context: context, onSuccess: onSuccess);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
