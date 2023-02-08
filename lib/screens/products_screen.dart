import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../widgets/app_drawer.dart';
import './cart_screen.dart';
import '../provider/cart.dart';
import '../widgets/badge_icon.dart';
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
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(_isInit) {
      setState(() {_isLoading = true;});
      Provider.of<Products>(context).fetchAndSetProducts();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
              builder : (_, cart, ch) { return Badge_Icon(
                value : cart.itemCount.toString(),
                child : IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.routeName);
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              );},
          ),
          const SizedBox(width: 5,),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                  if(_showOnlyFavorites == true) {
                    _showOnlyFavorites = false;
                  }
                });},
                child: Chip(
                    label: Text('All', style: Theme.of(context).textTheme.headline5,),
                    backgroundColor: _showOnlyFavorites ? Theme.of(context).colorScheme.secondary : Theme.of(context).canvasColor,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    if(_showOnlyFavorites != true) {
                      _showOnlyFavorites = true;
                    }
                  });
                },
                child: Chip(
                    label: Text('Favorites',style: Theme.of(context).textTheme.headline5,),
                    backgroundColor: _showOnlyFavorites ? Theme.of(context).canvasColor : Theme.of(context).colorScheme.secondary
                ),
              ),
            ],
          ),
          Expanded( child: ProductGrid(_showOnlyFavorites)),
        ],
      ),
    );
  }
}
