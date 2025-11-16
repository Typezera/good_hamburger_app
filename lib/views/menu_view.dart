import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_itens.dart';
import '../providers/menu_provider.dart';
import '../providers/cart_provider.dart';
import 'cart_view.dart';

//Use a consumer widget for watch a provider.
class MenuView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Listens to the status of the cart item list for notification 
    final cartItems = ref.watch(cartProvider);

    //Listens to the current status of the menu search
    final menuAsyncValue = ref.watch(menuListProvider);

    // get the cart notifier for the add logic
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Good Hamburger'),

        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  //Navigate to the cart screen
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartView()),
                  );
                },
              ),
              if(cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartItems.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          )
        ],
        // end update
      ),
      body: menuAsyncValue.when(
        //display loading during delay
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading menu...')
            ],
          ), 
        ),
        //show a error if any.
        error:  (err, stack) => Center(child: Text('Error loading menu: $err')),

        //show the data when ready
        data: (List<MenuItem> menuItem) {
          return ListView.builder(
            itemCount: menuItem.length,
            itemBuilder: (context, index) {
              final item = menuItem[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.category),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text("\$${item.price.toStringAsFixed(2)}")
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final error = cartNotifier.addItem(item);

                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.name} added!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      child: Text('Add'),
                    )
                  ],
                ),
              );
           }
          );
        }
      ),
    );
  }
}