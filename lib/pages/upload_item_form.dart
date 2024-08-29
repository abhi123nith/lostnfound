import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lostnfound/Utils/elevated_button.dart';
import 'package:lostnfound/pages/image_picker_button.dart';

class UploadItemForm extends StatefulWidget {
  final bool isLostItem;

  const UploadItemForm({super.key, required this.isLostItem});

  @override
  _UploadItemFormState createState() => _UploadItemFormState();
}

class _UploadItemFormState extends State<UploadItemForm> {
  String? selectedLocation;
  String? selectedSpecificLocation;
  String? selectedItemType;
  TextEditingController descriptionController = TextEditingController();
  List<PlatformFile>? pickedFiles;
  List<String> imageUrls = [];

  final List<String> itemTypes = [
    'Item Type',
    'ID Card',
    'Book',
    'Mobile Phone',
    'Laptop',
    'Earbuds',
    'Mobile Charger',
    'Laptop Charger',
    'Specs',
    'Watch',
    'Jewelry',
    'Jackets/Coats',
    'Shoes',
    'Umbrella',
    'Keys',
    'Electronics',
    'Water bottle',
    'Clothing',
    'Books',
    'Other',
  ];

  final List<String> locations = [
    'Campus',
    'Boys Hostel',
    'Girls Hostel',
    'Department',
    'Library',
    'Computer Center',
    'Lecture Hall',
    'New LH',
    'Auditorium',
    'OAT',
    'Ground',
    'Central Gym',
    'SP',
    '4 H',
    'Verka',
    'Amul',
    'Admin Block',
    'Central Block',
    'Food Court',
    'Nasecafe DBH',
    'GATE 1',
    'GATE 2',
    'Temple',
    'SAC',
  ];

  final List<String> boysHostels = [
    'KBH',
    'NBH',
    'UBH',
    'VBH',
    'DBH',
    'Himadri',
    'Himgiri'
  ];
  final List<String> girlsHostels = ['AGH', 'New AGH', 'PGH', 'MMH'];
  final List<String> departments = [
    'CSE',
    'Electrical',
    'Civil',
    'ECE',
    'MNC',
    'EP',
    'Chemical',
    'Mechanical',
    'Architecture',
    'MS'
  ];

  Future<void> uploadItem() async {
    if (_validateForm()) {
      try {
        imageUrls =
            await Future.wait(pickedFiles!.map((file) => _uploadImage(file)));
        await _submitItemDetails();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item uploaded successfully!')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload item')));
      }
    }
  }

  bool _validateForm() {
    if (selectedLocation == null ||
        selectedItemType == null ||
        descriptionController.text.isEmpty ||
        pickedFiles == null ||
        pickedFiles!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')));
      return false;
    }
    return true;
  }

  Future<String> _uploadImage(PlatformFile file) async {
    final imageBytes = file.bytes!;
    final imageName = file.name;
    final storageRef = FirebaseStorage.instance
        .ref('uploads/${widget.isLostItem ? 'Lost' : 'Found'}/$imageName');
    await storageRef.putData(imageBytes);
    return await storageRef.getDownloadURL();
  }

  Future<void> _submitItemDetails() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    final itemDetails = {
      'location': selectedLocation,
      'specificLocation': selectedSpecificLocation,
      'itemType': selectedItemType,
      'description': descriptionController.text.trim(),
      'imageUrls': imageUrls,
      'postedBy': currentUser?.uid ?? "User 123",
      'postedTime': Timestamp.now(),
      'profileImageUrl': currentUser?.photoURL ?? '',
    };

    try {
      String collectionName = widget.isLostItem ? 'lostItems' : 'foundItems';

      await FirebaseFirestore.instance
          .collection(collectionName)
          .add(itemDetails);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(widget.isLostItem
                ? 'Lost item posted successfully!'
                : 'Found item posted successfully!')),
      );

      descriptionController.clear();
      setState(() {
        pickedFiles = null;
        selectedItemType = null;
        selectedLocation = null;
        selectedSpecificLocation = null;
      });
    } catch (e) {
      print('Error uploading post: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to upload the item. Please try again.')));
    }
  }

  Future<void> pickImages() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.image);
    if (result != null) {
      setState(() {
        pickedFiles = result.files;
      });
    }
  }

  List<String> _getSpecificLocationItems(String location) {
    if (location == 'Boys Hostel') {
      return boysHostels;
    } else if (location == 'Girls Hostel') {
      return girlsHostels;
    } else if (location == 'Department') {
      return departments;
    } else {
      return [];
    }
  }

  String _getSpecificLocationLabel(String location) {
    if (location == 'Boys Hostel' || location == 'Girls Hostel') {
      return 'Hostel Name';
    } else if (location == 'Department') {
      return 'Department Name';
    } else {
      return 'Specific Location';
    }
  }

  @override
  Widget build(BuildContext context) {
    final specificLocationItems = selectedLocation != null
        ? _getSpecificLocationItems(selectedLocation!)
        : [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: selectedLocation,
            items: locations.map((location) {
              return DropdownMenuItem<String>(
                value: location,
                child: Text(location),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedLocation = value;
                selectedSpecificLocation = null;
              });
            },
            decoration: const InputDecoration(labelText: 'Location'),
          ),
          if (selectedLocation != null && specificLocationItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: DropdownButtonFormField<String>(
                value: selectedSpecificLocation,
                items: specificLocationItems.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSpecificLocation = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: _getSpecificLocationLabel(selectedLocation!),
                ),
              ),
            ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedItemType,
            items: itemTypes.map((itemType) {
              return DropdownMenuItem<String>(
                value: itemType,
                child: Text(itemType),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedItemType = value;
              });
            },
            decoration: const InputDecoration(labelText: 'Item Type'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 20),
          ImagePickerButton(
            onImagePicked: pickImages,
            fileNames: pickedFiles?.map((file) => file.name).toList(),
          ),
          const SizedBox(height: 20),
          if (pickedFiles != null && pickedFiles!.isNotEmpty)
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: pickedFiles!.map((file) {
                return Image.memory(
                  file.bytes!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                );
              }).toList(),
            ),
          const SizedBox(height: 20),
          ElevatedButtonWidget(
            onPressed: () async {
              if (mounted) {
                await uploadItem();
              }
            },
            text: 'Upload Item',
            backgroundColor: Colors.blue,
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}
