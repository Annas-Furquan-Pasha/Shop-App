import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';

class ProductDetailsScreen extends StatelessWidget {

  static const routeName = '/product-details';
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final id = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProducts = Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(loadedProducts.title,
        style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
