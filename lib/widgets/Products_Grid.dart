import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/Product_Item.dart';
import '../Providers/Products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavouritesOnly;

  ProductsGrid(this.showFavouritesOnly);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products =
        showFavouritesOnly ? productData.favouriteItems : productData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 24 / 25,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          // create: (context) => products[index],
          // builder: (context) => products[index],
          value: products[index],
          child: ProductItem(
              // products[index].id,
              // products[index].title,
              // products[index].imageUrl,
              ),
        );
      },
      itemCount: products.length,
    );
  }
}
