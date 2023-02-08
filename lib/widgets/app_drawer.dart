import 'package:flutter/material.dart';

import '../screens/user_products_screen.dart';
import '../screens/order_screen.dart';
import '../screens/products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            height: MediaQuery.of(context).size.height * 0.25,
            color: Theme.of(context).colorScheme.secondary,
            alignment: Alignment.bottomLeft,
            child: Text('Hello!\nHow was the day ?', style: Theme.of(context).textTheme.headline4, softWrap: true, overflow: TextOverflow.visible,)
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop,),
            title: const Text('Shop',style: TextStyle(fontSize: 17),),
            onTap: () {
              Navigator.pushReplacementNamed(context, ProductScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment,),
            title: const Text('Your Orders' ,style: TextStyle(fontSize: 17),),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrderScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit,),
            title: const Text('Manage Products' ,style: TextStyle(fontSize: 17),),
            onTap: () {
              Navigator.pushReplacementNamed(context, UserProductScreen.routeName);
            },
          )
        ],
      ),
    );
  }
}
