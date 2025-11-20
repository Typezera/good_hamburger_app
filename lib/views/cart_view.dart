import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import 'checkout_view.dart';

class CartView extends ConsumerWidget {
  @override 
  Widget build(BuildContext context, WidgetRef ref) {

    // Listen to the list of cart items
    final cartItems = ref.watch(cartProvider);

    //Access the notifier to have the removeitem
    final cartNotifier = ref.read(cartProvider.notifier);

    // Calculation of subtotal without discount
    final subtotal = cartItems.fold(0.0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: Text('Seu Carrinho (${cartItems.length} itens)'),
        backgroundColor: Colors.blueGrey, 
      ),
      body: Column(
        children: [
          //List of items in Cart
          Expanded(
            child: cartItems.isEmpty
              ? Center(child: Text('Your cart is empty!'))
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('\$${item.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 16),),
                            IconButton(
                              icon: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor),
                              onPressed:() {
                                cartNotifier.removeItem(item.id);
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
              ),
          ),
          // Subtotal area and end button
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 5),
              ],
            ),
            child: Column(
              children: [
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('\$${subtotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  //Navigate to the checkout screen
                  onPressed: cartItems.isEmpty ? null : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CheckoutView())
                    );
                  },
                  child: Text('Finish order'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}