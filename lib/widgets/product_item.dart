import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../provider/product.dart';
import '../screens/product_details.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context,  ProductDetailsScreen.routeName,
        arguments: product.id,
        );
      },
      child :GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
          leading: IconButton(
            icon: Icon( product.isFavorite ? Icons.favorite : Icons.favorite_border, size: 20,),
            onPressed: () {
              product.toggleFavorite();
            },
          ),
          trailing: IconButton(
            icon : const Icon(Icons.shopping_cart, size: 20,),
            onPressed : (){
              cart.addItems(product.id, product.price, product.title);
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
          child: Image.network(
            product.imageUrl,
              fit : BoxFit.cover,
          ),
      ),
    ),
    );
  }
}
