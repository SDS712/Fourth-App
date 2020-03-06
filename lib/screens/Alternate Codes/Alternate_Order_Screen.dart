// import 'package:flutter/material.dart';
// import 'package:new_shop_app/widgets/App_Drawer.dart';
// import 'package:provider/provider.dart';

// import '../Providers/Orders.dart';
// import '../widgets/Order_Item.dart' as orditm;

// class AlternateOrdersScreen extends StatefulWidget {
//   static const routeName = '/orders';

//   @override
//   _AlternateOrdersScreenState createState() => _AlternateOrdersScreenState();
// }

// class _AlternateOrdersScreenState extends State<AlternateOrdersScreen> {
//   bool isLoading = false;
//   @override
//   void initState() {
//     Future.delayed(Duration.zero).then((_) async {
//       setState(() {
//         isLoading = true;
//       });
//       await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
//       setState(() {
//         isLoading = false;
//       });
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final orders = Provider.of<Orders>(context);
//     return Scaffold(
//       drawer: AppDrawer(),
//       appBar: AppBar(
//         title: Text('Your Orders'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: orders.items.length,
//               itemBuilder: (context, index) => orditm.OrderItem(
//                 orders.items[index],
//               ),
//             ),
//     );
//   }
// }
