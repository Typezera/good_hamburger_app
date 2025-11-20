
class MenuItem {
  final String id;
  final String name;
  final double price;
  final String category;


  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json){
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      category: json['category'],
    );
  }

}

enum MenuFilter {
  all,
  sandwich,
  extra,
}