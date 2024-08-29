import 'package:flutter/material.dart';

class ItemListPage extends StatelessWidget {
  final List<Map<String, String>> items;
  final String title;
  final VoidCallback onUpload;

  const ItemListPage({
    super.key,
    required this.items,
    required this.title,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No items yet'))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GridTile(
                          footer: GridTileBar(
                            backgroundColor: Colors.black54,
                            title: Text(items[index]['location']!),
                            subtitle: Text(
                              '${items[index]['itemType']} - ${items[index]['description']}',
                            ),
                          ),
                          child: Image.network(items[index]['imageUrl']!,
                              fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
