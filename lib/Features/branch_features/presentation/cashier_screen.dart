import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CashierDeliveryScreen extends StatefulWidget {
  @override
  _CashierDeliveryScreenState createState() => _CashierDeliveryScreenState();
}

class _CashierDeliveryScreenState extends State<CashierDeliveryScreen> {
  List<dynamic> deliveryOrders = [];

  @override
  void initState() {
    super.initState();
    fetchDeliveryOrders();
  }

Future<void> fetchDeliveryOrders() async {
  final response = await http.get(
    Uri.parse('http://192.168.56.1:4000/user/delivery/deliveryOrders?orderType=delivery&branchId=2&inDeliveredOrders=false'),
  );

  if (response.statusCode == 200) {
    setState(() {
      deliveryOrders = json.decode(response.body)['data'];
    });
  } else {
    throw Exception('Failed to load delivery orders');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Orders'),
      ),
      body: deliveryOrders.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: deliveryOrders.length,
              itemBuilder: (context, index) {
                final order = deliveryOrders[index];
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text('Order ID: ${order['order_id']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Address: ${order['customer_address']}'),
                        Text('Phone: ${order['customer_phone']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
