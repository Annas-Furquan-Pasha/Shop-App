import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItems(String pId, double price, String title) {
    if(_items.containsKey(pId)) {
      _items.update(pId, (value) => CartItem(
        title: value.title,
        price: value.price,
        id: value.id,
        quantity: value.quantity +1,
      ));
    } else {
      _items.putIfAbsent(pId, () => CartItem(id: DateTime.now().toString(), price: price, quantity: 1, title: title));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear () {
    _items = {};
    notifyListeners();
  }
}