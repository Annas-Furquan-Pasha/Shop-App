import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductGrid(this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {

    final productsData = Provider.of<Products>(context);
    final loadedProducts = showFavorites ?  productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(13.0),
      itemCount: loadedProducts.length,
      itemBuilder : (_, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: const ProductItem(),
    ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3/2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
    );
  }
}
