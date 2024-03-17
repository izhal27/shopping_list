import 'package:shopping_list/models/category.dart';

class GroceryItem {
  const GroceryItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
  });

  final String id;
  final String name;
  final int amount;
  final Category category;
}
