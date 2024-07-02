import 'package:amazon_clone/commons/widgets/loader.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/features/admin/services/admin_service.dart';
import 'package:amazon_clone/features/admin/widgets/category_products_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminService _adminService = AdminService();
  int? totalSales;
  List<Sales>? sales;

  void getEarnings() async {
    final data = await _adminService.getAnalytics(context: context);
    totalSales = data['totalEarnings'];
    sales = data['sales'];
    print('totalSales: $totalSales');
    print('sales: ${sales![0].earning}');

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return totalSales == null || sales == null
        ? const Loader()
        : Column(
            children: [
              Text(
                'Tổng doanh thu: ${currencyFormat.format(totalSales)}VND',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 240,
                child: CategoryProductsChart(sales: sales!),
              ),
            ],
          );
  }
}
