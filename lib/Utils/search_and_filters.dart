import 'package:flutter/material.dart';
import 'package:lostnfound/Utils/dropdown_menu.dart';

class SearchAndFilters extends StatelessWidget {
  final String searchQuery;
  final String selectedType;
  final String selectedLocation;
  final String? selectedHostel;
  final ValueChanged<String?> onSearchQueryChanged;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onLocationChanged;
  final Future<void> Function(String) showDialog;
  final VoidCallback performSearch;

  const SearchAndFilters({
    super.key,
    required this.searchQuery,
    required this.selectedType,
    required this.selectedLocation,
    this.selectedHostel,
    required this.onSearchQueryChanged,
    required this.onTypeChanged,
    required this.onLocationChanged,
    required this.showDialog,
    required this.performSearch,
  });

  @override
  Widget build(BuildContext context) {
    final menu = AppDropdownMenu();
    const buttonHeight = 48.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search Found Items',
                  hintText: 'Enter keywords to search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: onSearchQueryChanged,
                controller: TextEditingController(text: searchQuery),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: performSearch,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(buttonHeight, buttonHeight),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Search',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: Container(
                height: buttonHeight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String?>(
                  value: selectedType,
                  onChanged: onTypeChanged,
                  items: menu.itemTypes.map((type) {
                    return DropdownMenuItem<String?>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  isExpanded: true,
                  hint: const Text('Select Item Type'),
                  underline: const SizedBox(), // Hide the default underline
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: Container(
                height: buttonHeight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: PopupMenuButton<String?>(
                  onSelected: (value) {
                    if (value == 'Boys Hostel' ||
                        value == 'Girls Hostel' ||
                        value == 'Department') {
                      showDialog(value!);
                    } else {
                      onLocationChanged(value);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    ...menu.locations.map((location) {
                      return PopupMenuItem<String?>(
                        value: location,
                        child: Text(location,
                            style: const TextStyle(fontSize: 16)),
                      );
                    }),
                  ],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedHostel ?? selectedLocation,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.arrow_drop_down, size: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        const Text(
          'Select filters to refine your search results.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
