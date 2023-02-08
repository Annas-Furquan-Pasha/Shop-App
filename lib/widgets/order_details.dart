import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_item.dart';

class OrderDetails extends StatefulWidget {

  final OrderItem order;

  const OrderDetails(this.order, {super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var _expand = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$ ${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd/MM/yyyy  hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon( _expand ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                    _expand = !_expand;
                });
              },
            ),
          ),
          if (_expand) Container(
            padding: const EdgeInsets.all(10),
            height: min(widget.order.products.length * 30.0 +10 , 100),
            child: ListView( children: widget.order.products.map((e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Text('${e.quantity}x \$${e.price}', style: const TextStyle(fontSize: 18, color: Colors.grey),)
              ],
            )).toList()),
          ),
        ],
      )
    );
  }
}
