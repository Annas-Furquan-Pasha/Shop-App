import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/edit_products.dart';
import './screens/user_products_screen.dart';
import './screens/order_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_details.dart';
import './provider/products.dart';
import './screens/products_screen.dart';
import './provider/cart.dart';
import './provider/orders.dart';
import '../screens/auth_screen.dart';
import '../provider/auth.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_) => Auth(),),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('', []),
          update: (ctx, auth, previousItems) => Products(auth.token!, previousItems==null ? [] : previousItems.items),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<Auth, Order>(
            create: (_) => Order('', []),
          update: (_, auth, previousOrders) => Order(auth.token!, previousOrders == null ? [] : previousOrders.orders),
        ),
        ],
      child: Consumer<Auth>(builder: (ctx, auth, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title : 'My Shop',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color.fromRGBO(170, 150, 218, 1),
              secondary: const Color.fromRGBO(197, 250, 213, 1),
            ),
            canvasColor: const Color.fromRGBO(255, 255, 210, 1),
            fontFamily: 'RobotoCondensed',
            textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 24.0, color: Colors.white),
              headline2: TextStyle(fontSize: 18.0, fontFamily: 'Raleway', color: Colors.white),
              headline3: TextStyle(fontSize: 20.0, fontFamily: 'Raleway',),
              headline4: TextStyle(fontFamily: 'Raleway', color: Colors.black54, fontSize: 24.0,),
              headline5: TextStyle(fontSize: 19.0, fontFamily: 'RobotoCondensed', color: Colors.black),
            )
        ),
        home : auth.isAuth ? const ProductScreen() : const AuthScreen(),
        routes: {
          ProductScreen.routeName: (_) => const ProductScreen(),
          ProductDetailsScreen.routeName : (_) => const ProductDetailsScreen(),
          CartScreen.routeName : (_) => const CartScreen(),
          OrderScreen.routeName : (_) => const OrderScreen(),
          UserProductScreen.routeName : (_) => const UserProductScreen(),
          EditProducts.routeName: (_) => const EditProducts(),
        },
      ),)
    );
  }
}