import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Providers/Orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(0.9),
              border: Border.all(width: 0.5),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '\$${widget.orderItem.totalAmount}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(widget.orderItem.products.length > 1
              ? '${widget.orderItem.products[0].title}....and ${widget.orderItem.products.length - 1} more'
              : '${widget.orderItem.products[0].title}'),
          subtitle: Text(
            DateFormat('dd/MM/yyyy').add_jm().format(widget.orderItem.dateTime),
          ),
          trailing: IconButton(
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
        if (_expanded)
          Divider(
            thickness: 2.0,
          ),
        if (_expanded)
          Container(
            height: min(
              //Takes the smallest value
              widget.orderItem.products.length * 100.0 + 10,
              200,
            ),
            child: ListView(
              children: widget.orderItem.products.map((product) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(product.title),
                      subtitle: Text('\$${product.price}'),
                      trailing: Text('${product.quantity} x'),
                    ),
                    Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    ));
  }
}
