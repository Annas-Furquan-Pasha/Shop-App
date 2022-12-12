import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_details.dart';
import '../provider/orders.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const routeName = '/order-screen';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: (_, index) => OrderDetails(orders.orders[index]),
        itemCount: orders.totalOrders(),
      ),
    );
  }
}
