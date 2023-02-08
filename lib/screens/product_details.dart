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
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget> [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Card(
                    elevation: 5,
                    child: Image.network(loadedProducts.imageUrl,),
                  ),
                ),
                const SizedBox(height: 10,),
                Center(child: Text('Price - ${loadedProducts.price}', style: Theme.of(context).textTheme.headline4,)),
                const SizedBox(height: 10,),
                Center(child: Text(loadedProducts.title, style: Theme.of(context).textTheme.headline4,)),
                const SizedBox(height: 10.0,),
                Center(child : Text(loadedProducts.description, style: Theme.of(context).textTheme.headline4, overflow: TextOverflow.visible, softWrap: true,)),
              ],
            ),
          ),
      ),
    );
  }
}
