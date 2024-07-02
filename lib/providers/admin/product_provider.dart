import 'package:flutter/material.dart';
import 'package:amazon_clone/models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _products.removeWhere((element) => element.id == product.id);
    notifyListeners();
  }

  void setProducts(List<Product> products) {
    _products = products;
  }
}
