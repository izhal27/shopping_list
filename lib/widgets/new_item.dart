import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = "";
  var _enteredAmount = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'flutter-prep-f63f3-default-rtdb.asia-southeast1.firebasedatabase.app',
          'grocery-list.json');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredAmount,
            'category': _selectedCategory.title
          },
        ),
      );

      if (response.statusCode == 200) {
        if (!context.mounted) {
          return;
        }

        final Map<String, dynamic> addItem = json.decode(response.body);

        Navigator.of(context).pop(GroceryItem(
          id: addItem['name'],
          name: _enteredName,
          quantity: _enteredAmount,
          category: _selectedCategory,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Item'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                initialValue: _enteredName,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return "Minimal 2 sampai 50 karakter";
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Quantity"),
                      ),
                      initialValue: _enteredAmount.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return "Harus angka dan lebih besar dari 0";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredAmount = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: category.value.color,
                                    ),
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(category.value.title),
                                ],
                              ),
                            ),
                          )
                      ],
                      onChanged: (category) {
                        setState(() {
                          _selectedCategory = category!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text("Add Item"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
