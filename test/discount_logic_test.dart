import 'package:flutter_test/flutter_test.dart';
import 'package:good_hamburger_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:good_hamburger_app/models/menu_itens.dart';
import 'package:good_hamburger_app/providers/cart_provider.dart';


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MyApp(),
      ),
    );
  });

  const burger = MenuItem(id: 'b01', name: 'Burger', price: 5.00, category: 'Sandwich');
  const fries = MenuItem(id: 'f01', name: 'Fries', price: 2.00, category: 'Extra');
  const softDrink = MenuItem(id: 's01', name: 'Soft drink', price: 2.50, category: 'Extra');
  const otherExtra = MenuItem(id: 'x01', name: 'Onion Rings', price: 3.00, category: 'Extra');

  group('Discount Calculation Logic', () {
    late CartNotifier cartNotifier;


    setUp(() {
      cartNotifier = CartNotifier();
    });


    test('Should apply 20% discount for full combo (Sandwich, Fries, Soft Drink)', () {

      cartNotifier.addItem(burger);
      cartNotifier.addItem(fries);
      cartNotifier.addItem(softDrink);

      final result = cartNotifier.calculateDiscount();
      

      expect(result.subtotal, equals(9.50));
      expect(result.discountPercentage, equals(20.0));
      expect(result.discountAmount, equals(1.90));
      expect(result.finalTotal, equals(7.60)); 
      expect(result.ruleApplied, equals('20% Complete combo'));
    });
    

    test('Should apply 0% discount if only a sandwich is selected', () {

      cartNotifier.addItem(burger);

      final result = cartNotifier.calculateDiscount();
      

      expect(result.subtotal, equals(5.00));
      expect(result.discountPercentage, equals(0.0));
      expect(result.discountAmount, equals(0.0));
      expect(result.finalTotal, equals(5.00));
      expect(result.ruleApplied, equals('No discount applied'));
    });


    test('Should apply 15% discount for Sandwich + Soft Drink combo', () {

      cartNotifier.addItem(burger);
      cartNotifier.addItem(softDrink);


      final result = cartNotifier.calculateDiscount();
      

      expect(result.subtotal, equals(7.50));
      expect(result.discountPercentage, equals(15.0));

      expect(result.discountAmount, closeTo(1.13, 0.01)); 
      expect(result.finalTotal, closeTo(6.38, 0.01)); 
    });


    test('Should apply 10% discount for Sandwich + Fries combo', () {

      cartNotifier.addItem(burger);
      cartNotifier.addItem(fries);

      final result = cartNotifier.calculateDiscount();
      
      expect(result.subtotal, equals(7.00));
      expect(result.discountPercentage, equals(10.0));
      expect(result.discountAmount, equals(0.70)); 
      expect(result.finalTotal, equals(6.30)); 
    });
  });
}
