// lib/pages/found_page.dart
import 'package:flutter/material.dart';
import 'package:lostnfound/Utils/search_and_filters.dart';
import 'package:lostnfound/pages/dialogdisplay.dart';
import 'package:lostnfound/pages/item_list_page.dart';
import 'package:lostnfound/pages/upload_item_page.dart';

class FoundPage extends StatefulWidget {
  const FoundPage({super.key});

  @override
  _FoundPageState createState() => _FoundPageState();
}

class _FoundPageState extends State<FoundPage> {
  List<Map<String, String>> foundItems = [];
  List<Map<String, String>> filteredFoundItems = [];
  String searchQuery = '';
  String selectedType = 'Item Type';
  String selectedLocation = 'Campus';
  String? selectedHostel;

  Future<void> navigateToUploadPage() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UploadItemPage(isLostItem: false),
      ),
    );
    if (newItem != null) {
      setState(() {
        foundItems.add(newItem);
        _filterItems();
      });
    }
  }

  void updateSearchQuery(String? query) {
    setState(() {
      searchQuery = query ?? '';
    });
  }

  void _filterItems() {
    setState(() {
      filteredFoundItems = foundItems
          .where((item) =>
              (selectedType == 'Item Type' || item['type'] == selectedType) &&
              (selectedLocation == 'Item Type' ||
                  item['location'] == selectedLocation) &&
              item['description']!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  void _performSearch() {
    _filterItems();
  }

  Future<void> _showDialog(String category) async {
    final selectedItem = await showSelectionDialog(context, category);
    if (selectedItem != null) {
      setState(() {
        selectedHostel = selectedItem;
        selectedLocation = category; // Update the location
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
            performSearch: _performSearch,
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ItemListPage(
              items: filteredFoundItems,
              title: 'Found Items',
              onUpload: navigateToUploadPage,
            ),
          ),
        ],
      ),
    );
  }
}
