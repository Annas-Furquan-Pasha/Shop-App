import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class CartDetails extends StatelessWidget {

  final String id;
  final String pId;
  final String title;
  final int quantity;
  final double price;

  const CartDetails({super.key,
    required this.id,
    required this.pId,
    required this.title,
    required this.quantity,
    required this.price
});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(pId),
      direction: DismissDirection.endToStart,
      background: Container(
        margin:  const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 20,
        ),
      ),
      onDismissed: (_) {
        Provider.of<Cart>(context, listen : false).removeItem(pId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Padding(padding: const EdgeInsets.all(5), child:FittedBox(child: Text('\$$price')),),
            ),
            title: Text(title),
            subtitle: Text('Total:\$ ${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
