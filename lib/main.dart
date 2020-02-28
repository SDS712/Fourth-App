import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/Product_Detail_Screen.dart';
import './screens/Products_Overview_Screen.dart';
import './screens/Edit_Product_Screen.dart';
import './screens/Orders_Screen.dart';
import './screens/Cart_Screen.dart';
import './screens/User_Products_Screen.dart';
import './Providers/Products.dart';
import './Providers/Cart.dart';
import './Providers/Orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          // create: (context) => Products(),
          // builder: (context) => Products(),
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepPurple,
          fontFamily: 'Lato',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(color: Colors.white),
              ),
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
          UserProductScreen.routeName: (context) => UserProductScreen(),
          EditProductScreen.routeName:(context)=>EditProductScreen(),
        },
      ),
    );
  }
}
