import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
 List<Product> _items;
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //     'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //     'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //     'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //     'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];
  final String authToken;

  Products(this.authToken, this._items);

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse('https://flutter-update-3e477-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.get(url);
        final data = json.decode(response.body);// as Map<String, dynamic>;
        if(data == null) {
          return;
        }
        final extractedData = data as Map<String, dynamic>;
        final List<Product> loadedProducts = [];
        extractedData.forEach((pId, pData) {
          loadedProducts.add(Product(id: pId,
              title: pData['title'],
              description: pData['description'],
              price: pData['price'],
              imageUrl: pData['imageUrl'],
              isFavorite: pData['isFavorite']));
        });

      _items = loadedProducts;
      notifyListeners();
    } catch (e) {print('...');}
}

  Future<void> addProduct(Product product) {
    final url = Uri.parse('https://flutter-update-3e477-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    return http.post(url, body: json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl' : product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite
    }),).then((response) {
      final newProduct = Product(
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> update(String id, Product p) async {
    final pIndex = _items.indexWhere((element) => element.id == id);
    if(pIndex >= 0) {
      final url = Uri.parse('https://flutter-update-3e477-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url, body: json.encode({
        'title' : p.title,
        'description' : p.description,
        'imageUrl' : p.imageUrl,
        'price' : p.price,
      }));
      _items[pIndex] = p;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('https://flutter-update-3e477-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProdIndex = _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProdIndex];
    _items.removeAt(existingProdIndex);
    notifyListeners();
    final response = await http.delete(url);
      if(response.statusCode >= 400) {
        _items.insert(existingProdIndex, existingProduct);
        notifyListeners();
        throw HttpException('could not delete product');
      }
      existingProduct = null;
  }
}