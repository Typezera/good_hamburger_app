import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../models/discount_result.dart';
import '../providers/order_provider.dart';

class CheckoutView extends ConsumerWidget {
  final TextEditingController nameController = TextEditingController();

  @override  
  Widget build(BuildContext context, WidgetRef ref) {
    //Listens to the status of the cart and calculates the discount
    final result = ref.watch(cartProvider.notifier).calculatedDiscount();

    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Finish Order'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Calculation summary
            Text("Order Summary", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Divider(),
            _buildPriceRow('Subtotal:', result.subtotal, isBold: false),
            _buildPriceRow('Discount Applied (${result.discountPercentage.toStringAsFixed(0)}%):',
                          result.discountAmount,
                          color: Colors.red),
            _buildPriceRow('Final total:', result.finalTotal, isBold: true, fontSize: 24),

            SizedBox(height: 10),
            Text('Rule: ${result.ruleApplied ?? 'None'}', style: TextStyle(fontStyle: FontStyle.italic)),

            Spacer(),
            
            //Requirement: User must enter only the name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Your Name: ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
              ),

            ),
            SizedBox(height: 20),

            //Button submit
            ElevatedButton(
              onPressed: () {
                if(nameController.text.trim().isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter your name'),
                      backgroundColor: Colors.red,
                  ),
                );
                  return;
                }
                ref.read(orderProvider.notifier).submitOrder(
                  nameController.text.trim(), //client name
                  cartItems,                  //itens on cart
                  result,                     
                ); 
                //clear cart
                ref.read(cartProvider.notifier).clearCart();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order Submitted Successfully'),
                    backgroundColor: Colors.green,
                  ),
                );

                // navigate back to the main screen
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Submit Order', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                maximumSize: Size(double.infinity, 55),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            )
          ],
        )
      )
    );
  }

  Widget _buildPriceRow(String label, double value, {Color? color, bool isBold = false, double fontSize = 18} ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text('\$${value.toStringAsFixed(2)}', style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
        ],
      )
    );
  }
}