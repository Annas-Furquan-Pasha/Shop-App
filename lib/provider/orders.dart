import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/order_item.dart';

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  int totalOrders() {
    return _orders.length;
  }

  void addOrder(List<CartItem> cartProducts, double amount) {
    _orders.insert(0, OrderItem(id: DateTime.now().toString(), amount: amount, products: cartProducts, dateTime: DateTime.now()));
    notifyListeners();
  }
}