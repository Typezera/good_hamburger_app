import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:good_hamburger_app/providers/order_provider.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';

class OrdersView extends ConsumerWidget {
  @override  
  Widget build(BuildContext context, WidgetRef ref){
    final submittedOrders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History (${submittedOrders.length})'),
        backgroundColor: Colors.indigo,
      ),
      body: submittedOrders.isEmpty
          ? Center(child: Text('No requests submitted yet'))
          : ListView.builder(
              itemCount: submittedOrders.length,
              itemBuilder: (context, index) {
                final order = submittedOrders[index];
                return ExpansionTile(
                  title: Text(
                    'Order #${submittedOrders.length - index} by ${order.customerName}',
                  ),
                  subtitle: Text(
                    DateFormat('dd/MM/yy HH:mm').format(order.submissionTime),
                  ),
                  children: [
                    //order details
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...order.items.map((item) => Text('${item.name} (\$${item.price.toStringAsFixed(2)})')).toList(),
                          Divider(),
                          Text('Discount: ${order.calculationResult.discountPercentage.toStringAsFixed(0)}%', style: TextStyle(color: Colors.red)),
                          Text('Total Pago: \$${order.calculationResult.finalTotal.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),

                    )
                  ],
                );
              }
        ) 

    );
  }
}