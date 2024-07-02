import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? passwordConfirm;
  final String? address;
  final String? role;
  final String? token;
  final List<dynamic> cart;
  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.passwordConfirm,
    this.address,
    this.role,
    this.token,
    required this.cart,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? passwordConfirm,
    String? address,
    String? role,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      address: address ?? this.address,
      role: role ?? this.role,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'address': address,
      'role': role,
      'token': token,
      'cart': cart,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      passwordConfirm: map['passwordConfirm'] != null ? map['passwordConfirm'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      cart: List<dynamic>.from((map['cart'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, password: $password, passwordConfirm: $passwordConfirm, address: $address, role: $role, token: $token, cart: $cart)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.passwordConfirm == passwordConfirm &&
        other.address == address &&
        other.role == role &&
        other.token == token &&
        listEquals(other.cart, cart);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        passwordConfirm.hashCode ^
        address.hashCode ^
        role.hashCode ^
        token.hashCode ^
        cart.hashCode;
  }
}
