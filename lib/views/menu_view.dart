// lib/views/menu_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_itens.dart';
import '../providers/menu_provider.dart'; 
import '../providers/cart_provider.dart'; 
import 'cart_view.dart';
import 'orders_view.dart';
import '../providers/menu_filter_provider.dart';
import '../widgets/menu_item_card.dart';

class MenuView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final cartItems = ref.watch(cartProvider);

    final menuAsyncValue = ref.watch(filteredMenuListProvider); 
    
    // final filterNotifier = ref.read(menuFilterProvider.notifier);
ref.invalidate(filteredMenuListProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Good Hamburger'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => OrdersView()),
              );
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartView()),
                  );
                },
              ),
              if (cartItems.isNotEmpty) 
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${cartItems.length}',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // _buildFilterButton(context, 'Todos', MenuFilter.all, activeFilter, filterNotifier),
                // _buildFilterButton(context, 'Sanduíches', MenuFilter.sandwich, activeFilter, filterNotifier),
                // _buildFilterButton(context, 'Extras', MenuFilter.extra, activeFilter, filterNotifier),
              ],
            ),
          ),
          
          // 2. LISTA (Usa Expanded e aplica os estados do FutureProvider)
          Expanded(
            child: menuAsyncValue.when(
              
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator(), SizedBox(height: 20), Text('Loading menu...')]
                ),
              ),
              
              error: (err, stack) => Center(child: Text('Error loading menu: $err')),
              
              data: (List<MenuItem> menuItems) {
                if(menuItems.isEmpty){
                  return Center(child: Text('No items found in this category'));
                }

                return ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];

                    return MenuItemCard(item: item);
                  }
                );
              }
            ),
          ),
        ],
      ), 
    );
  }

  Widget _buildFilterButton(BuildContext context, String title, MenuFilter filter, MenuFilter activeFilter, /*StateController<MenuFilter> notifier */) {
    final isSelected = activeFilter == filter;
    return ElevatedButton(
      onPressed: () {}/*=> notifier.state = filter */,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blueGrey : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(title),
    );
  }
}