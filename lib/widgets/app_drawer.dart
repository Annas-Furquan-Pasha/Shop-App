import 'package:flutter/material.dart';

import '../screens/order_screen.dart';
import '../screens/products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Hello!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('shop'),
            onTap: () {
              Navigator.pushReplacementNamed(context, ProductScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('orders'),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrderScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
