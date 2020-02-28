import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './Edit_Product_Screen.dart';
import '../widgets/App_Drawer.dart';
import '../widgets/User_Product_Item.dart';
import '../Providers/Products.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/User-Products';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: productData.items.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              UserProductItem(
                id:productData.items[index].id,
                title: productData.items[index].title,
                imageUrl: productData.items[index].imageUrl,
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
