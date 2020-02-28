import 'package:flutter/material.dart';
import 'package:new_shop_app/widgets/App_Drawer.dart';
import 'package:provider/provider.dart';

import '../Providers/Orders.dart';
import '../widgets/Order_Item.dart' as orditm;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.items.length,
        itemBuilder: (context, index) => orditm.OrderItem(
          orders.items[index],
        ),
      ),
    );
  }
}
