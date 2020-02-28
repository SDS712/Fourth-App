import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/Product_Detail_Screen.dart';
import '../Providers/Product.dart';
import '../Providers/Cart.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // );
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Theme.of(context).accentColor.withOpacity(0.65),
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              icon: product.isFavourite
                  ? Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.favorite_border,
                    ),
              onPressed: () => product.toggleisFavourite(),
            ),
          ),
          title: Text(product.title),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItems(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added to Cart'),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                    textColor: Theme.of(context).primaryColor.withRed(1000),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
