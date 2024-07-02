// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:amazon_clone/models/product.dart';

class Order {
  final String? id;
  final List<Product> products;
  final List<int> quantity;
  final num totalPrice;
  final String address;
  final String user;
  final num status;
  final DateTime createdAt;

  Order({
    this.id,
    required this.products,
    required this.quantity,
    required this.totalPrice,
    required this.address,
    required this.user,
    required this.status,
    required this.createdAt,
  });

  Order copyWith({
    String? id,
    List<Product>? products,
    List<int>? quantity,
    num? totalPrice,
    String? address,
    String? user,
    num? status,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      products: products ?? this.products,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      address: address ?? this.address,
      user: user ?? this.user,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'quantity': quantity,
      'totalPrice': totalPrice,
      'address': address,
      'user': user,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] != null ? map['id'] as String : null,
      products: List<Product>.from(
        (map['products'] as List<dynamic>).map(
          (x) => Product.fromMap(x['product']),
        ),
      ),
      quantity: List<int>.from(map['products'].map((x) => x['quantity'])),
      totalPrice: map['totalPrice'] as num,
      address: map['address'] as String,
      user: map['user'] as String,
      status: map['status'] as num,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, products: $products, quantity: $quantity, totalPrice: $totalPrice, address: $address, user: $user, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        listEquals(other.products, products) &&
        listEquals(other.quantity, quantity) &&
        other.totalPrice == totalPrice &&
        other.address == address &&
        other.user == user &&
        other.status == status &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        products.hashCode ^
        quantity.hashCode ^
        totalPrice.hashCode ^
        address.hashCode ^
        user.hashCode ^
        status.hashCode ^
        createdAt.hashCode;
  }
}
