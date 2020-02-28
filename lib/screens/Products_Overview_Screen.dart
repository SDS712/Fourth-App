import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/App_Drawer.dart';
import '../widgets/badge.dart';
import '../screens/Products_Grid.dart';
import '../screens/Cart_Screen.dart';
import '../Providers/Cart.dart';

enum Options {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showFavouritesOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
              value: cart.itemCount.toString(),
            ),
            // child:
            // IconButton(
            //   icon: Icon(Icons.shopping_cart),
            //   onPressed: () {
            //     Navigator.of(context).pushNamed(CartScreen.routeName);
            //   },
            // ),
          ),
          PopupMenuButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.more_vert),
            onSelected: (Options selectedValue) {
              setState(() {
                if (selectedValue == Options.Favourites) {
                  return showFavouritesOnly = true;
                }
                return showFavouritesOnly = false;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Favourites',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ],
                ),
                value: Options.Favourites,
              ),
              PopupMenuItem(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.all_inclusive,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Show All',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ],
                ),
                value: Options.All,
              ),
            ],
          ),
        ],
      ),
      body: ProductsGrid(showFavouritesOnly),
    );
  }
}
