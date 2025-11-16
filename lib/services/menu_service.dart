import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/menu_itens.dart';


class MenuService {
  Future<List<MenuItem>> fetchMenu() async {
    // simulates network delay
    await Future.delayed(Duration(seconds: 1));

    //load  the file from the 'lib/data/' directory
    final String response = await rootBundle.loadString('lib/data/menu_data.json');

    final List<dynamic> data = json.decode(response);

    return data.map((json) => MenuItem.fromJson(json)).toList();
  }
}