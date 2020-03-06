import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './Edit_Product_Screen.dart';
import '../widgets/App_Drawer.dart';
import '../widgets/User_Product_Item.dart';
import '../Providers/Products.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/User-Products';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context, listen: true);
    print('reBuilding...');
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
      body:
          /*RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Consumer<Products>(
          builder: (context, productData, _) => ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  UserProductItem(
                    id: productData.items[index].id,
                    title: productData.items[index].title,
                    imageUrl: productData.items[index].imageUrl,
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ), */
          FutureBuilder(
        future:
            //Provider.of<Products>(context, listen: false)
            // .fetchAndSetProducts(true),//This doesn't work for some reason
            _refreshProducts(context),
        builder: (context, dataSnapShot) =>
            dataSnapShot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, productData, _) => ListView.builder(
                        itemCount: productData.items.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              UserProductItem(
                                id: productData.items[index].id,
                                title: productData.items[index].title,
                                imageUrl: productData.items[index].imageUrl,
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
      ),
    );
  }
}
