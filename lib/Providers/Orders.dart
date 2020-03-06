import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  final String authToken;
  final String userId;

  Orders(this.authToken,this.userId, this._items);

  List<OrderItem> get items {
    if (_items == []) {
      return [];
    } else {
      return [..._items];
    }
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://my-server-270c6.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final extractedOrders = json.decode(response.body) as Map<String, dynamic>;
    if (extractedOrders == null) {
      return;
    }
    List<OrderItem> loadedOrders = [];
    extractedOrders.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          totalAmount: orderData['totalAmount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ))
              .toList()));
    });
    _items = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartItems, double totalAmount) async {
    final url =
        'https://my-server-270c6.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'totalAmount': totalAmount,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartItems
                .map(
                  (cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  },
                )
                .toList(),
          },
        ),
      );
      _items.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          totalAmount: totalAmount,
          products: cartItems,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
