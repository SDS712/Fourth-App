import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/Cart.dart' show Cart; //imports only Cart from the model
import '../Providers/Orders.dart';

import '../widgets/Cart_Item.dart' as ci; //imports with a specific name

class CartScreen extends StatelessWidget {
  static const routeName = '/Cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context); //listener with listen set to true
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Text('Total'),
                  Spacer(),
                  Chip(
                    //container with large border radius
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) {
                  return ci.CartItem(
                    id: cart.items.values.toList()[index].id,
                    title: cart.items.values.toList()[index].title,
                    price: cart.items.values.toList()[index].price,
                    quantity: cart.items.values.toList()[index].quantity,
                    productId: cart.items.keys.toList()[index],
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return FlatButton(
      onPressed: (widget.cart.itemCount <= 0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrders(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              scaffold.showSnackBar(
                  SnackBar(content: Text('Thankyou for Ordering!')));
              setState(() {
                isLoading = false;
              });
              widget.cart.clearCart();
            },
      child: isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
