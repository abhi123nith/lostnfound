import 'package:flutter/material.dart';

class ItemListPage extends StatelessWidget {
  final List<Map<String, String>> items;
  final String title;
  final Future<void> Function() onUpload;
  final Widget Function(BuildContext, Map<String, String>) itemBuilder;

  const ItemListPage({
    super.key,
    required this.items,
    required this.title,
    required this.onUpload,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: onUpload,
          child: const Text('Upload New Item'),
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return itemBuilder(context, items[index]);
            },
          ),
        ),
      ],
    );
  }
}
