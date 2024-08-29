import 'package:flutter/material.dart';

class ItemTypeDialog extends StatelessWidget {
  final Text title;
  final Text content;
  final String button1name;
  final String button2name;
  final Function(bool) onItemSelected;

  const ItemTypeDialog(
      {super.key,
      required this.onItemSelected,
      required this.title,
      required this.content,
      required this.button1name,
      required this.button2name});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: <Widget>[
        TextButton(
          child: Text(button1name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.of(context).pop();
            onItemSelected(true); 
          },
        ),
        TextButton(
          child: Text(button2name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.of(context).pop();
            onItemSelected(false); // Trigger navigation with 'false' for Found
          },
        ),
      ],
    );
  }
}
