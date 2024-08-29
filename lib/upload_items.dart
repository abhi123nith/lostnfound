import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadItemPage extends StatefulWidget {
  final bool isLostItem; // To differentiate between Lost and Found
  const UploadItemPage({super.key, required this.isLostItem});

  @override
  _UploadItemPageState createState() => _UploadItemPageState();
}

class _UploadItemPageState extends State<UploadItemPage> {
  String? selectedLocation;
  String? selectedItemType;
  TextEditingController descriptionController = TextEditingController();
  FilePickerResult? pickedFile;
  String? imageUrl;

  Future<void> uploadItem() async {
    if (selectedLocation != null &&
        selectedItemType != null &&
        descriptionController.text.isNotEmpty &&
        pickedFile != null &&
        pickedFile!.files.single.bytes != null) {
      try {
        final imageBytes = pickedFile!.files.single.bytes!;
        final imageName = pickedFile!.files.single.name;

        // Upload image to Firebase
        final storageRef = FirebaseStorage.instance
            .ref('uploads/${widget.isLostItem ? 'Lost' : 'Found'}/$imageName');
        await storageRef.putData(imageBytes);
        imageUrl = await storageRef.getDownloadURL();

        // Add the item details to Firebase or your local state management
        // (Assuming you have a method to add the details to your database)

        Navigator.pop(context, {
          'location': selectedLocation,
          'itemType': selectedItemType,
          'description': descriptionController.text,
          'imageUrl': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item uploaded successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload item')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  Future<void> pickImage() async {
    pickedFile = await FilePicker.platform.pickFiles(type: FileType.image);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isLostItem ? 'Upload Lost Item' : 'Upload Found Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Location'),
                items: const [
                  DropdownMenuItem(value: 'Hostel', child: Text('Hostel')),
                  DropdownMenuItem(value: 'Library', child: Text('Library')),
                  DropdownMenuItem(value: 'Cafeteria', child: Text('Cafeteria')),
                  DropdownMenuItem(value: 'Gym', child: Text('Gym')),
                  DropdownMenuItem(value: 'Classroom', child: Text('Classroom')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value;
                  });
                },
                value: selectedLocation,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Item Type'),
                items: const [
                  DropdownMenuItem(value: 'Book', child: Text('Book')),
                  DropdownMenuItem(value: 'Wallet', child: Text('Wallet')),
                  DropdownMenuItem(value: 'Electronics', child: Text('Electronics')),
                  DropdownMenuItem(value: 'Clothing', child: Text('Clothing')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedItemType = value;
                  });
                },
                value: selectedItemType,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Select Image'),
              ),
              if (pickedFile != null) Text('Selected Image: ${pickedFile!.files.single.name}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadItem,
                child: const Text('Upload Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
