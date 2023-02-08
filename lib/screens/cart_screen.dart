import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './order_screen.dart';
import '../provider/orders.dart';
import '../widgets/cart_details.dart';
import '../provider/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total', style: Theme.of(context).textTheme.headline3,),
                  const Spacer(),
                  Chip(label: Text('\$ ${cart.totalAmount.toStringAsFixed(2)}'), backgroundColor: Theme.of(context).colorScheme.secondary,),
                  TextButton(onPressed: () {
                    if(cart.items.isNotEmpty) {
                      Provider.of<Order>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      cart.clear();
                      Navigator.pushNamed(context, OrderScreen.routeName);
                    }
                  },
                    child: const Text('Order Now'),
                  ),
                ],
              ),
            ),
          ),
          if (cart.items.isNotEmpty)
          Expanded(
              child: ListView.builder(
              itemBuilder: (_, index) => CartDetails(
                id: cart.items.values.toList()[index].id,
                pId : cart.items.keys.toList()[index],
                title: cart.items.values.toList()[index].title,
                price: cart.items.values.
                toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
              ),
                itemCount: cart.items.length,
              ),
          ),
          if (cart.items.isEmpty) Text('No Items in the Cart!!' , style: Theme.of(context).textTheme.headline4,),
        ],
      ),
    );
  }
}
