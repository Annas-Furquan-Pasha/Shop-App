import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_products_item.dart';
import '../provider/products.dart';
import './edit_products.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routeName = '/user-products-screen';

  Future<void> _refresh (BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('User Products ', style: Theme.of(context).textTheme.headline1,),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.add), onPressed: () {Navigator.pushNamed(context, EditProducts.routeName);}, ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (_, snapShot) => snapShot.connectionState== ConnectionState.waiting ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: Consumer<Products>(
            builder: (ctx, productsData, _) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  itemBuilder: (_, index) => UserProductItem(
                    productsData.items[index].id,
                    productsData.items[index].title,
                    productsData.items[index].imageUrl,
                  ),
                 itemCount: productsData.items.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
