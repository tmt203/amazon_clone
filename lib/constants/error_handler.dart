import 'dart:convert';

import 'package:amazon_clone/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
    case 201:
      onSuccess();
      break;
    // case 400:
    //   showSnackBar(context, jsonDecode(response.body).message);
    //   break;
    // case 500:
    //   showSnackBar(context, jsonDecode(response.body).message);
    //   break;
    case 204:
      showSnackBar(context, 'Xóa thành công');
      break;
    case 401:
      showSnackBar(context, jsonDecode(response.body)['message']);
      break;
    default:
      showSnackBar(context, jsonDecode(response.body)['message']);
  }
}
