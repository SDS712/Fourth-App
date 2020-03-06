import 'package:flutter/material.dart';
import 'package:new_shop_app/widgets/App_Drawer.dart';
import 'package:provider/provider.dart';

import '../Providers/Orders.dart';
import '../widgets/Order_Item.dart' as orditm;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
        },
        child: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (context, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } /*else if (dataSnapShot.data == null) {//Doesn't work for some unknown reason
              return AlertDialog(
                title: Text(
                  'No Orders Placed yet',
                  style: TextStyle(color: Colors.black),
                ),
                actions: <Widget>[
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/');
                    },
                    label: Text('Go back to home Page'),
                    icon: Icon(Icons.chevron_left),
                  ),
                ],
              );
            }*/
            else if (dataSnapShot.error != null) {
              return AlertDialog(
                title: Text(
                  'An Error Occurred',
                  style: TextStyle(color: Colors.black),
                ),
                content: Text('Couldn\'t load your orders!'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/');
                    },
                    child: Text('Try Again'),
                  ),
                ],
              );
            } else {
              return Consumer<Orders>(
                builder: (context, orders, child) => orders.items.length == 0
                    ? AlertDialog(
                        title: Text(
                          'No Orders Placed yet',
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: <Widget>[
                          FlatButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/');
                            },
                            label: Text('Go back to home Page'),
                            icon: Icon(Icons.chevron_left),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: orders.items.length,
                        itemBuilder: (context, index) => orditm.OrderItem(
                          orders.items[index],
                        ),
                      ),
              );
            }
          },
        ),
      ),
    );
  }
}
