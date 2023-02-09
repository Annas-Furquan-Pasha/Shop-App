import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cart_item.dart';
import '../models/order_item.dart';

class Order with ChangeNotifier {
  List<OrderItem> _orders ;
  final String authToken;
  Order(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  int totalOrders() {
    return _orders.length;
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse('https://flutter-update-3e477-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final data = json.decode(response.body); //as Map<String, dynamic>;
    if(data == null ) {
      return;
    }
    final extractedData = data as Map<String, dynamic>;
    extractedData.forEach((oId, oData) {
      loadedOrders.add(OrderItem(id: oId, amount: oData['amount'],dateTime: DateTime.parse(oData['dateTime']),
          products: (oData['products'] as List<dynamic>)
          .map((item) =>
          CartItem(id: item['id'], title: item['title'], price: item['price'], quantity: item['quantity']))
          .toList()));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double amount) async {
    final url = Uri.parse('https://flutter-update-3e477-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final time = DateTime.now();
    final response = await http.post(url, body: json.encode({
      'amount': amount,
      'dateTime' : time.toIso8601String(),
      'products' : cartProducts.map((cp) => {
        'id' : cp.id,
        'title' :cp.title,
        'quantity': cp.quantity,
        'price' : cp.price,
      }).toList(),
    }),);
    _orders.insert(0, OrderItem(id: json.decode(response.body)['name'], amount: amount, products: cartProducts, dateTime: time));
    notifyListeners();
  }
}