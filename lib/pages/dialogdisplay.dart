import 'package:flutter/material.dart';
import 'package:lostnfound/Utils/dropdown_menu.dart';

Future<String?> showSelectionDialog(
    BuildContext context, String category) async {
  final List<String> items;
  final String dialogTitle;

  switch (category) {
    case 'Boys Hostel':
      items = AppDropdownMenu.boysHostels;
      dialogTitle = 'Boys Hostels';
      break;
    case 'Girls Hostel':
      items = AppDropdownMenu.girlsHostels;
      dialogTitle = 'Girls Hostels';
      break;
    case 'Department':
      items = AppDropdownMenu.departments;
      dialogTitle = 'Departments';
      break;
    default:
      return null;
  }

  return showDialog<String?>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(dialogTitle),
        content: SingleChildScrollView(
          child: ListBody(
            children: items.map((item) {
              return ListTile(
                title: Text(item),
                onTap: () {
                  Navigator.of(context).pop(item);
                },
              );
            }).toList(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
