import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String
      id; //final is added as these values won't change but can be replaced with new values during updates
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite; //final not added as this value will be switchable in app

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleisFavourite(String authToken, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://my-server-270c6.firebaseio.com/userFavourites/UserID-$userId/ProductID-$id.json?auth=$authToken';
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavourite,
          ));
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }
}
