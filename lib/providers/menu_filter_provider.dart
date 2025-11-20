import '../models/menu_itens.dart';
import 'package:riverpod/riverpod.dart';

class MenuFilterController {
  MenuFilter filter = MenuFilter.all;

  void setFilter(MenuFilter newFilter) {
    filter = newFilter;
  }
}

final menuFilterProvider = Provider<MenuFilterController>((ref) {
  return MenuFilterController();
});