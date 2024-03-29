import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';

import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GroceryListState();
  }
}

class _GroceryListState extends State<GroceryList> {
  var _groceryItems = <GroceryItem>[];
  var _isLoading = true;
  var _error = "";

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    Map<String, dynamic> listData = {};

    try {
      final url = Uri.https(
          'flutter-prep-f63f3-default-rtdb.asia-southeast1.firebasedatabase.app',
          'grocery-list.json');
      final res = await http.get(url);
      listData = json.decode(res.body);

      if (res.statusCode >= 400 || res.body == 'null') {
        setState(() {
          _error = "Terjadi kesalahan dalam mengambil data, coba lagi nanti.";
          _isLoading = false;
        });
        return;
      }
    } catch (e) {
      setState(() {
        _error = "Terjadi kesalahan, coba lagi nanti.";
        _isLoading = false;
      });
    }

    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (category) => category.value.title == item.value['category'])
          .value;

      loadedItems.add(GroceryItem(
        id: item.key,
        name: item.value['name'],
        quantity: item.value['quantity'],
        category: category,
      ));
    }

    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final item = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (item == null) {
      return;
    }

    setState(() {
      _groceryItems.add(item);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https(
        'flutter-prep-f63f3-default-rtdb.asia-southeast1.firebasedatabase.app',
        'grocery-list.json');
    final res = await http.delete(url);

    if (res.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("Data masih kosong."),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) {
          final item = _groceryItems[index];

          return Dismissible(
            direction: DismissDirection.endToStart,
            key: ValueKey(item.id),
            onDismissed: (direction) {
              _removeItem(item);
            },
            child: ListTile(
              title: Text(item.name),
              leading: Container(
                width: 24,
                height: 24,
                color: item.category.color,
              ),
              trailing: Text(item.quantity.toString()),
            ),
          );
        },
      );
    }

    if (_error.isNotEmpty) {
      content = Center(
        child: Text(_error),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }
}
