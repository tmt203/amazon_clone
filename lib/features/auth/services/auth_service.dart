import 'dart:convert';

import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amazon_clone/commons/widgets/bottom_bar.dart';
import 'package:amazon_clone/constants/error_handler.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/models/user.dart';

class AuthService {
  // sign up
  void signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
        address: '',
        role: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/signup'),
        body: user.toJson(),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (!context.mounted) return;

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Tạo tài khoản thành công!');
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  // signin
  void signin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/auth/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final userData = jsonDecode(res.body)['data']['user'];
          final token = jsonDecode(res.body)['token'];

          userData['token'] = token;

          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(userData);
          await prefs.setString('x-auth-token', token);
          Future.delayed(Duration.zero, () {
            if (userData['role'] == 'admin') {
              Navigator.pushNamedAndRemoveUntil(context, AdminScreen.routeName, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, BottomBar.routeName, (route) => false);
            }
          });
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  Future<void> getUserData({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        prefs.setString('x-auth-token', '');
        return;
      }

      http.Response userResponse = await http.get(Uri.parse('$uri/api/users/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      Provider.of<UserProvider>(context, listen: false).setUser(jsonDecode(userResponse.body)['data']);
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(context, e.toString());
    }
  }
}
