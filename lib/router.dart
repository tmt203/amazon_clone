import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/order_detail/screens/order_detail_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/commons/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/product_detail/screens/product_detail_screen.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/home/screens/category_deals_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const BottomBar(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AddProductScreen(),
      );
    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AdminScreen(),
      );
    case CategoryDealsScreen.routeName:
      final String category = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => CategoryDealsScreen(category: category),
      );
    case SearchScreen.routeName:
      final String searchQuery = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => SearchScreen(searchQuery: searchQuery),
      );

    case ProductDetailScreen.routeName:
      final Product product = routeSettings.arguments as Product;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => ProductDetailScreen(product: product),
      );

    case AddressScreen.routeName:
      final String totalAmount = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => AddressScreen(totalAmount: totalAmount),
      );
    case OrderDetailScreen.routeName:
      final Order order = routeSettings.arguments as Order;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => OrderDetailScreen(order: order),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('404 Page'),
          ),
        ),
      );
  }
}
