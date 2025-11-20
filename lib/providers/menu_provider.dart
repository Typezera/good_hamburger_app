import 'package:riverpod/riverpod.dart';
import '../models/menu_itens.dart';
import '../services/menu_service.dart';

//make the service instance of (Singleton)
final MenuServiceProvider = Provider((ref) => MenuService());

//FutureProvider management a async search menu

final menuListProvider = FutureProvider<List<MenuItem>>((ref) async {
  //User service for search a data
  return ref.read(MenuServiceProvider).fetchMenu();
});

final menuFilterProvider = Provider<MenuFilter>((ref) => MenuFilter.all);


final filteredMenuListProvider = Provider<AsyncValue<List<MenuItem>>>((ref) {
  final menuAsyncValue = ref.watch(menuListProvider);
  final activeFilter = ref.watch(menuFilterProvider);


  return menuAsyncValue.when(
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
    
    data: (menuItems) {
      final filteredList = menuItems.where((item) {
        switch (activeFilter) {
          case MenuFilter.all:
            return true;
          case MenuFilter.sandwich:
            return item.category == 'Sandwich';
          case MenuFilter.extra:
            return item.category == 'Extra';
        }
      }).toList();
      
      return AsyncValue.data(filteredList);
    },
  );
});