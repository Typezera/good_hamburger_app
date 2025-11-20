import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:good_hamburger_app/models/discount_result.dart';
import '../models/menu_itens.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<MenuItem>>((ref) {
  return CartNotifier();
});


class CartNotifier extends StateNotifier<List<MenuItem>> {

  CartNotifier() : super([]);

  String? addItem(MenuItem item) {

    if (item.category == 'Sandwich') {
      final hasSandwich = state.any((cartItem) => cartItem.category == 'Sandwich');
      if (hasSandwich) {
        return 'Erro: You can only select one sandwich per order.';
      }
    }

    if (item.name == 'Fries') {
      final hasFries = state.any((cartItem) => cartItem.name == 'Fries');
      if (hasFries){
        return 'Erro: You can only add a portion of fries';
      }
    }

    if(item.name == 'Soft drink') {
      final hasSoftDrink = state.any((cartItem) => cartItem.name == 'Soft drink');
      if (hasSoftDrink) {
        return 'Error: You can only add one soda.';
      }
    }

    state = [...state, item];
    return null; 
  }

  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }

  //clear cart
  void clearCart() {
    state = [];
  }

  DiscountResult calculatedDiscount() {
    final subtotal = state.fold(0.0, (sum, item) => sum + item.price);

    if(state.isEmpty){
      return DiscountResult(
        subtotal: 0.0,
        discountAmount: 0.0,
        finalTotal: 0.0,
        discountPercentage: 0.0,
      );
    }

    final hasSandwich = state.any((item) => item.category == 'Sandwich');
    final hasFries = state.any((item) => item.name == 'Fries');
    final hasSoftDrink = state.any((item) => item.name == 'Soft drink');

    double discountRate = 0.0;
    String? rule = 'No discount applied';

    if (hasSandwich && hasFries && hasSoftDrink) {
      discountRate = 0.20; 
      rule = '20% Complete combo';
    }

    else if(hasSandwich && hasSoftDrink) {
      discountRate = 0.15; 
      rule = '15% Sandwich and Soda';
    }

    else if(hasSandwich && hasFries){
      discountRate = 0.10; 
      rule = '10% sandwich and Fries';
    }

    final discountAmount = subtotal * discountRate;
    final finalTotal = subtotal - discountAmount;

    return DiscountResult(
      subtotal: subtotal,
      discountAmount: discountAmount,
      finalTotal: finalTotal,
      discountPercentage: discountRate * 100,
      ruleApplied: rule,
    );
  }

  DiscountResult calculateDiscount() {
    final subtotal = state.fold(0.0, (sum, item) => sum + item.price);

    if(state.isEmpty){
      return DiscountResult(
        subtotal: 0.0,
        discountAmount: 0.0,
        finalTotal: 0.0,
        discountPercentage: 0.0,
      );
    }

    final hasSandwich = state.any((item) => item.category == 'Sandwich');
    final hasFries = state.any((item) => item.name == 'Fries');
    final hasSoftDrink = state.any((item) => item.name == 'Soft drink');

    double discountRate = 0.0;
    String? rule = 'No discount applied';

    if(hasSandwich && hasFries && hasSoftDrink){
      discountRate = 0.20;
      rule = '20% Complete combo';
    }

    else if (hasSandwich && hasSoftDrink){
      discountRate = 0.15;
      rule = '15% Sandwich and Soda';
    }

    else if (hasSandwich && hasFries) {
      discountRate = 0.10;
      rule = '10% sandwich and Fries';
    }

    final discountAmount = subtotal * discountRate;
    final finalTotal = subtotal - discountAmount;

    return DiscountResult(
      subtotal: subtotal,
      discountAmount: discountAmount,
      finalTotal: finalTotal,
      discountPercentage: discountRate * 100,
      ruleApplied: rule,
    );
  }

}