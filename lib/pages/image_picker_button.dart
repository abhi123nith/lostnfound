import 'package:flutter/material.dart';
import 'package:lostnfound/Utils/elevated_button.dart';

class ImagePickerButton extends StatelessWidget {
  final Future<void> Function() onImagePicked;
  final List<String>? fileNames;

  const ImagePickerButton({
    required this.onImagePicked,
    this.fileNames,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonWidget(
      onPressed: onImagePicked,
      text: (fileNames == null || fileNames!.isEmpty
          ? 'Select Images'
          : 'Selected: ${fileNames!.length} image(s)'),
      icon: Icons.collections,
    );
  }
}
