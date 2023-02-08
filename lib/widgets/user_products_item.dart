import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_products.dart';
import '../provider/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, EditProducts.routeName, arguments: id);
                  },
                  icon: const Icon(Icons.edit),
                  color : Theme.of(context).colorScheme.primary,
                ),
                IconButton(
                    onPressed: () {
                      Provider.of<Products>(context, listen: false).deleteProduct(id);
                    },
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
