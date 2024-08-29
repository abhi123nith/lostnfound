// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:lostnfound/Utils/lost_item_widget.dart';
import 'package:lostnfound/Utils/search_and_filters.dart';
import 'package:lostnfound/pages/dialogdisplay.dart';
import 'package:lostnfound/pages/upload_item_page.dart';

class LostPage extends StatefulWidget {
  const LostPage({super.key});

  @override
  _LostPageState createState() => _LostPageState();
}

class _LostPageState extends State<LostPage> {
  List<Map<String, dynamic>> lostItems = [];
  List<Map<String, dynamic>> filteredLostItems = [];
  String searchQuery = '';
  String selectedType = 'Item Type';
  String selectedLocation = 'Campus';
  String? selectedHostel;

  @override
  void initState() {
    super.initState();
    _fetchLostItems();
  }

  Future<void> _fetchLostItems() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('lostItems').get();

      List<Map<String, dynamic>> fetchedItems = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        // Convert Firestore's Timestamp to a formatted date string
        if (data['postedTime'] is Timestamp) {
          Timestamp timestamp = data['postedTime'];
          DateTime dateTime = timestamp.toDate();
          data['postedTime'] =
              DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
        }

        // Ensure 'imageUrls' is a list of strings
        data['imageUrls'] = List<String>.from(data['imageUrls'] ?? []);

        return data;
      }).toList();

      setState(() {
        lostItems = fetchedItems;
        _filterItems();
      });
    } catch (e) {
      print("Failed to fetch lost items: $e");
    }
  }

  Future<void> navigateToUploadPage() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UploadItemPage(isLostItem: true),
      ),
    );

    if (newItem != null) {
      setState(() {
        lostItems.add(newItem);
        _filterItems();
      });
      await FirebaseFirestore.instance.collection('lostItems').add(newItem);
    }
  }

  void updateSearchQuery(String? query) {
    setState(() {
      searchQuery = query ?? '';
      _filterItems();
    });
  }

  void _filterItems() {
    setState(() {
      filteredLostItems = lostItems.where((item) {
        bool matchesType =
            selectedType == 'Item Type' || item['itemType'] == selectedType;
        bool matchesLocation = selectedLocation == 'Campus' ||
            item['areaOfLoss'] == selectedLocation;
        bool matchesHostel = (selectedLocation != 'Boys Hostel' &&
                selectedLocation != 'Girls Hostel' &&
                selectedLocation != 'Department') ||
            (selectedHostel == null || item['hostel'] == selectedHostel);
        bool matchesSearch = item['description']!
            .toLowerCase()
            .contains(searchQuery.toLowerCase());

        return matchesType && matchesLocation && matchesHostel && matchesSearch;
      }).toList();
    });
  }

  Future<void> _showDialog(String category) async {
    final selectedItem = await showSelectionDialog(context, category);
    if (selectedItem != null) {
      setState(() {
        selectedHostel = selectedItem;
        selectedLocation = category;
        _filterItems();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search and filters widget
          SearchAndFilters(
            searchQuery: searchQuery,
            selectedType: selectedType,
            selectedLocation: selectedLocation,
            selectedHostel: selectedHostel,
            onSearchQueryChanged: updateSearchQuery,
            onTypeChanged: (value) {
              setState(() {
                selectedType = value ?? '';
                _filterItems();
              });
            },
            onLocationChanged: (value) {
              setState(() {
                selectedLocation = value ?? '';
                selectedHostel =
                    null; // Reset hostel selection if a different location is chosen
                _filterItems();
              });
            },
            showDialog: _showDialog,
            performSearch: _filterItems,
          ),
          const SizedBox(height: 16.0),
          // Display filtered lost items
          const Expanded(
              child: LostItemListWidget(),
            ),
        ],
      ),
    );
  }
}
