import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/App_Drawer.dart';
import '../widgets/badge.dart';
import '../widgets/Products_Grid.dart';

import '../screens/Cart_Screen.dart';

import '../Providers/Cart.dart';
import '../Providers/Products.dart';

enum Options {
  //Remember enums map every item with a index
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showFavouritesOnly = false;
  bool isInit = true;
  bool isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts();//This doesn't work here

    /*Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context).fetchAndSetProducts();
    });*/ //This does work in the initstate

    // Provider.of<Products>(context,listen: false).fetchAndSetProducts();This also work here
    //but we'll be using it in didChangeDependencies
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          Consumer<Cart>(
            //Consumers are special listeners which always listen and take a builder function and a child
            //when the state of the provider(in this case 'cart') is changed, only the builder function inside of the consumer is run
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
            icon: Icon(Icons.more_vert /*3 dot icon*/),
            onSelected: (Options
                selectedValue /*automatically passes a selected value*/) {
              setState(() {
                if (selectedValue == Options.Favourites) {
                  return showFavouritesOnly = true;
                }
                return showFavouritesOnly = false;
              });
            },
            itemBuilder: (_) => [
              //PopUpMenuButton takes a itemBuilder
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
                value: Options
                    .Favourites, //if pressed, this value is passed to the function passed to onSelected argument
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await Provider.of<Products>(context, listen: false)
                    .fetchAndSetProducts();
              },
              child: ProductsGrid(showFavouritesOnly)),
    );
  }
}
