import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_item.dart';

class OrderDetails extends StatelessWidget {

  final OrderItem order;

  const OrderDetails(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$ ${order.amount}'),
            subtitle: Text(DateFormat.yMMMd().format(order.dateTime)),
            trailing: IconButton(
              icon: const Icon(Icons.expand),
              onPressed: () {},
            ),
          )
        ],
      )
    );
  }
}
