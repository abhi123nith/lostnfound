import 'package:flutter/material.dart';
import 'upload_item_form.dart';

class UploadItemPage extends StatelessWidget {
  final bool isLostItem;
  const UploadItemPage({super.key, required this.isLostItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLostItem ? 'Upload Lost Item' : 'Upload Found Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UploadItemForm(isLostItem: isLostItem),
      ),
    );
  }
}
