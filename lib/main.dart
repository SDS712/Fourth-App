import 'package:flutter/material.dart';
import 'package:new_shop_app/screens/Splash_Screen.dart';
import 'package:provider/provider.dart';

import './screens/Product_Detail_Screen.dart';
import './screens/Alternate_Auth_Screen.dart';
// import './screens/Auth_Screen.dart';
import './screens/Products_Overview_Screen.dart';
import './screens/Edit_Product_Screen.dart';
import './screens/Orders_Screen.dart';
import './screens/Cart_Screen.dart';
import './screens/User_Products_Screen.dart';

import './Providers/Products.dart';
import './Providers/Cart.dart';
import './Providers/Orders.dart';
import './Providers/Auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //This class is used to provide multiple 'Providers'
      //(for managing app-wide state of 'Providers' which contains classes with stored Data)to its child
      providers: [
        //So, these acts as the 'Data Providers' for the overall app
        ChangeNotifierProvider.value(
          //'ChangeNotifierProvider' is a Provider based on 'ChangeNotifier' class
          value:
              Auth(), //classes provided in the 'value' argument of ChangeNotifierProvider must be defined with mixin of ChangeNotifier
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          //ProxyProvider is a provider that combines multiple values from other providers into a new object, and sends the result to Provider
          create: (context) {
            return;
          },
          // builder: (context) => Products(),
          update: (context, auth, previousProductsState) => Products(
              auth.token,
              auth.userId,
              previousProductsState == null ? [] : previousProductsState.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) {
            return;
          },
          update: (context, auth, previousOrdersState) => Orders(
            auth.token,
            auth.userId,
            previousOrdersState == null ? [] : previousOrdersState.items,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepPurple,
            fontFamily: 'Lato',
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(color: Colors.white),
                ),
          ),
          home:
              // ProductsOverviewScreen(),
              auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoSignIn(),
                      builder: (context, dataSnapShot) =>
                          dataSnapShot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
          routes: {
            //all namedRoutes must be registered in the routes table
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
