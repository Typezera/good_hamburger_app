import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_itens.dart';
import '../services/menu_service.dart';

//make the service instance of (Singleton)
final MenuServiceProvider = Provider((ref) => MenuService());

//FutureProvider management a async search menu

final menuListProvider = FutureProvider<List<MenuItem>>((ref) async {
  //User service for search a data
  return ref.read(MenuServiceProvider).fetchMenu();
});

