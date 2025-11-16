import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/order.dart';
import '../models/discount_result.dart';
import '../models/menu_itens.dart';


//the orderPRovider stores a list of all orders already submitted.
final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
  return OrderNotifier();
});

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]);

  void submitOrder(String customerName, List<MenuItem> items, DiscountResult result) {
    // created a new order object
    final newOrder = Order(
      customerName: customerName,
      items: List.from(items),
      calculationResult: result,
      submissionTime: DateTime.now(),
    );

    state = [...state, newOrder];
  }
}