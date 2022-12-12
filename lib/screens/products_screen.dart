import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import './cart_screen.dart';
import '../provider/cart.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  static const routeName = '/product-screen';

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        elevation: 0.0,
        title : Text('My Shop',
        style: Theme.of(context).textTheme.headline1,
        ),
        actions: <Widget>[
          Consumer<Cart> (
              builder : (_, cart, ch) => Badge(
                value : cart.itemCount.toString(),
                child : IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.routeName);
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                if(value == FilterOptions.Favorites) {
                  _showOnlyFavorites= true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon : const Icon(Icons.more_vert,),
            itemBuilder: (_) => [
               const PopupMenuItem(value: FilterOptions.Favorites, child: Text('Only Favorites'),),
               const PopupMenuItem(value: FilterOptions.All, child: Text('All'),),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductGrid(_showOnlyFavorites),

    );
  }
}
