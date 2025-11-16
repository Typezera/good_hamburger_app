import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/menu_itens.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<MenuItem>>((ref) {
  return CartNotifier();
});


class CartNotifier extends StateNotifier<List<MenuItem>> {

  CartNotifier() : super([]);

  String? addItem(MenuItem item) {

    // Rule  just one sandwich
    if (item.category == 'Sandwich') {
      final hasSandwich = state.any((cartItem) => cartItem.category == 'Sandwich');
      if (hasSandwich) {
        return 'Erro: You can only select one sandwich per order.';
      }
    }

    // Rule 2 : Just one portion of Fries
    if (item.name == 'Fries') {
      final hasFries = state.any((cartItem) => cartItem.name == 'Fries');
      if (hasFries){
        return 'Erro: You can only add a portion of fries';
      }
    }

    // Rule 3 : Just one soft drink
    if(item.name == 'Soft drink') {
      final hasSoftDrink = state.any((cartItem) => cartItem.name == 'Soft drink');
      if (hasSoftDrink) {
        return 'Error: You can only add one soda.';
      }
    }

    state = [...state, item];
    return null; 
  }

  //clear cart
  void clearCart() {
    state = [];
  }
}