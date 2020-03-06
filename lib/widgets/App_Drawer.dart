import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/Orders_Screen.dart';
import '../screens/User_Products_Screen.dart';

import '../Providers/Auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            //Yes!! you can add an appBar to the Drawer
            title: Text('My Shop'),
            automaticallyImplyLeading:
                false, //This I think doesn't show back button
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Home'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.menu,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Your Orders'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Manage Products'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Log Out'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).pop(); //To pop the drawer.
              Navigator.of(context).pushReplacementNamed('/');//to go to home screen before logging out
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
