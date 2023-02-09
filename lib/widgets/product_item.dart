import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../provider/product.dart';
import '../screens/product_details.dart';
import '../provider/auth.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final tokenData = Provider.of<Auth>(context, listen: false);
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
            icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border, size: 20,),
            onPressed: () {
                product.toggleFavorite(tokenData.token);
            },
          ),
          trailing: IconButton(
            icon : const Icon(Icons.shopping_cart, size: 20,),
            onPressed : (){
              cart.addItems(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 2),
                content: const Text('Added item to cart'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: (){
                    cart.removeSingleItem(product.id);
                  }
                ),
              ));
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
