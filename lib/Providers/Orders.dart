import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './Cart.dart';

class OrderItem {
  final String id;
  final double totalAmount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    this.id,
    this.totalAmount,
    this.dateTime,
    this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  addOrders(List<CartItem> cartItems, double totalAmount) {
    _items.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        totalAmount: totalAmount,
        products: cartItems,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
