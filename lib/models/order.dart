import 'menu_itens.dart';
import 'discount_result.dart';

class Order {
  final String customerName;
  final List<MenuItem> items;
  final DiscountResult calculationResult;
  final DateTime submissionTime;

  Order ({
    required this.customerName,
    required this.items,
    required this.calculationResult,
    required this.submissionTime,
  });
}