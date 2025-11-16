
class DiscountResult {
  final double subtotal;
  final double discountAmount;
  final double finalTotal;
  final double discountPercentage;
  final String? ruleApplied; 


  DiscountResult ({
    required this.subtotal,
    required this.discountAmount,
    required this.finalTotal,
    required this.discountPercentage,
    this.ruleApplied,
  });
}


