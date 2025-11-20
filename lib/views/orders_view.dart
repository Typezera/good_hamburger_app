import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; 
import '../providers/order_provider.dart';

class OrdersView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submittedOrders = ref.watch(orderProvider);
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History (${submittedOrders.length})'),
        backgroundColor: primaryColor, 
      ),
      body: submittedOrders.isEmpty
          ? Center(child: Text('No order submitted yet.'))
          : ListView.builder(
              itemCount: submittedOrders.length,
              itemBuilder: (context, index) {
                final order = submittedOrders[submittedOrders.length - 1 - index]; // Mostra o mais recente primeiro
                
                return Card(
                  elevation: 4, 
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.all(16.0),
                    
                    title: Text(
                      'Order #${submittedOrders.length - index} by ${order.customerName}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      'Submetido em: ${DateFormat('dd/MM/yy HH:mm').format(order.submissionTime)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    
                    trailing: Text(
                      '\$${order.calculationResult.finalTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    ),
                    
                    children: [
                      Divider(height: 1, color: Colors.grey[300]),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Itens:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                            SizedBox(height: 8),

                            ...order.items.map((item) => Padding(
                              padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
                              child: Text('— ${item.name} (\$${item.price.toStringAsFixed(2)})'),
                            )).toList(),
                            
                            SizedBox(height: 10),
                            Divider(),
                            
                            _buildSummaryRow('Subtotal:', order.calculationResult.subtotal, context),
                            _buildSummaryRow(
                              'Discount (${order.calculationResult.discountPercentage.toStringAsFixed(0)}%):', 
                              -order.calculationResult.discountAmount, // Exibe o valor do desconto como negativo/vermelho
                              context, 
                              isDiscount: true
                            ),
                            
                            Divider(color: Colors.black),
                            
                            _buildSummaryRow('Total Paid:', order.calculationResult.finalTotal, context, isTotal: true),
                            
                            SizedBox(height: 8),
                            Text('Regra Aplicada: ${order.calculationResult.ruleApplied}', 
                              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[700])),

                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
  
  Widget _buildSummaryRow(String label, double value, BuildContext context, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            )
          ),
          Text(
            (isDiscount ? '-' : '') + '\$${value.abs().toStringAsFixed(2)}', 
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 16 : 14,
              color: isDiscount ? Colors.red : (isTotal ? Theme.of(context).primaryColor : Colors.black87)
            )
          ),
        ],
      ),
    );
  }
}