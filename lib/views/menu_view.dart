import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_itens.dart';
import '../providers/menu_provider.dart';

//Use a consumer widget for watch a provider.
class MenuView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Listens to the current status of the menu search
    final menuAsyncValue = ref.watch(menuListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Good Hamburger'),
      ),
      body: menuAsyncValue.when(
        //display loading during delay
        loading: () => Center(child: CircularProgressIndicator()),
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
                      onPressed: () => print("Add ${item.name}"),
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