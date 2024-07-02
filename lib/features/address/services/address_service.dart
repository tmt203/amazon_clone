import 'dart:convert';

import 'package:amazon_clone/constants/error_handler.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressService {
  Future<List<Map<String, dynamic>>> fetchProvinces({required BuildContext context}) async {
    List<Map<String, dynamic>> provinces = [];
    try {
      http.Response response = await http.get(Uri.parse("$vpa/province"));

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          provinces = List<Map<String, dynamic>>.from(jsonDecode(response.body)['results']);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    return provinces;
  }

  Future<List<Map<String, dynamic>>> fetchDistricts({
    required BuildContext context,
    required String provinceCode,
  }) async {
    List<Map<String, dynamic>> districts = [];
    try {
      http.Response response = await http.get(Uri.parse("$vpa/province/district/$provinceCode"));

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          districts = List<Map<String, dynamic>>.from(jsonDecode(response.body)['results']);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    return districts;
  }

  Future<List<Map<String, dynamic>>> fetchWards({
    required BuildContext context,
    required String districtCode,
  }) async {
    List<Map<String, dynamic>> wards = [];
    try {
      http.Response response = await http.get(Uri.parse("$vpa/province/ward/$districtCode"));

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          wards = List<Map<String, dynamic>>.from(jsonDecode(response.body)['results']);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    return wards;
  }

  Future<void> saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');

    try {
      http.Response response = await http.patch(
        Uri.parse('$uri/api/users/updateMe'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'address': address,
        }),
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          print('TEST');
          print(jsonDecode(response.body));
          User user = userProvider.user!.copyWith(address: jsonDecode(response.body)['data']['address']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  Future<void> placeOrder({
    required BuildContext context,
    required String address,
    required double totalPrice,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('x-auth-token');
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/orders/place-order"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'address': address,
          'totalPrice': totalPrice,
          'cart': userProvider.user!.cart,
        }),
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Đặt hàng thành công');
          User user = userProvider.user!.copyWith(cart: []);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }
}
