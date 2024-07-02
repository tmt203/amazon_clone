import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '');

String dateFormat(DateTime dateTime) {
  // Add 7 hours to the provided DateTime
  dateTime = dateTime.add(const Duration(hours: 7));

  // Format the DateTime object into the desired format
  String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);

  // Return the formatted date as a String
  return formattedDate;
}

void showSnackBar(BuildContext context, String text) {
  SnackBar snackbar = SnackBar(
    content: Text(text),
    backgroundColor: Colors.indigo,
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 150, left: 10, right: 10),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    var files = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'webp']);
    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return images;
}
