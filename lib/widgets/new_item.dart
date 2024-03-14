import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Item'),
      ),
      body: Form(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  return 'foo';
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Amount"),
                      ),
                      initialValue: "1",
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField(
                      items: [],
                      onChanged: (item) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
