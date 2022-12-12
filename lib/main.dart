import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/order_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_details.dart';
import './provider/products.dart';
import './screens/products_screen.dart';
import './provider/cart.dart';
import './provider/orders.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create :(_) => Products()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Order()),
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title : 'My Shop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color.fromRGBO(170, 150, 218, 1),
              secondary: const Color.fromRGBO(197, 250, 213, 1),
          ),
          canvasColor: const Color.fromRGBO(255, 255, 210, 1),
          fontFamily: 'Raleway',
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 24.0, color: Colors.white),
            headline2: TextStyle(fontSize: 18.0, fontFamily: 'RobotoCondensed', color: Colors.white),
            headline3: TextStyle(fontSize: 20.0, fontFamily: 'RobotoCondensed',)
          )
        ),
        home : const ProductScreen(),
        routes: {
          ProductScreen.routeName: (_) => const ProductScreen(),
          ProductDetailsScreen.routeName : (_) => const ProductDetailsScreen(),
          CartScreen.routeName : (_) => const CartScreen(),
          OrderScreen.routeName : (_) => const OrderScreen(),
        },
      ),
    );
  }
}