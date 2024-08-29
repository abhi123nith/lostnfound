import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lostnfound/Utils/dropdown_menu.dart';

class LostItemListWidget extends StatelessWidget {
  const LostItemListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('lostItems')
          .orderBy('postedTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No lost items found'));
        }

        final items = snapshot.data!.docs;

        // Debugging output
        print('Fetched ${items.length} items');

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final itemData = items[index].data() as Map<String, dynamic>;
            print('Item data: $itemData'); // Debugging output

            final locationType = itemData['locationType'] as String?;
            final location = itemData['location'] as String?;

            // Default display value
            String locationDisplay = 'Location Not Specified';

            if (locationType != null && location!.isNotEmpty) {
              switch (locationType) {
                case 'Campus':
                  locationDisplay = 'Campus';
                  break;
                case 'Boys Hostel':
                  locationDisplay =
                      AppDropdownMenu.boysHostels.contains(location)
                          ? location
                          : 'Unknown Boys Hostel';
                  break;
                case 'Girls Hostel':
                  locationDisplay =
                      AppDropdownMenu.girlsHostels.contains(location)
                          ? location
                          : 'Unknown Girls Hostel';
                  break;
                case 'Department':
                  locationDisplay =
                      AppDropdownMenu.departments.contains(location)
                          ? location
                          : 'Unknown Department';
                  break;
                default:
                  locationDisplay = 'Location Not Specified';
                  break;
              }
            }

            return Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User profile image and details
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: CachedNetworkImage(
                            imageUrl: itemData['profileImageUrl'] ?? '',
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              width: 40.0,
                              height: 40.0,
                              child: const CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              width: 40.0,
                              height: 40.0,
                              child: const Icon(Icons.error, size: 40.0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                itemData['postedBy'] ?? 'Anonymous',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                'Posted On: ${itemData['postedTime']?.toDate().toLocal().toString() ?? 'Unknown'}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Item Type: ${itemData['itemType'] ?? 'Not Specified'}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Location: $locationDisplay',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),

                    // Description
                    Text(
                      itemData['description'] ?? 'No Description Available',
                      style: Theme.of(context).textTheme.bodyLarge,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),

                    // Image(s)
                    if (itemData['imageUrls'] != null &&
                        (itemData['imageUrls'] as List).isNotEmpty)
                      SizedBox(
                        height: 200.0, // Adjust the height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: (itemData['imageUrls'] as List).length,
                          itemBuilder: (context, index) {
                            final imageUrl =
                                (itemData['imageUrls'] as List)[index];
                            print('Image URL: $imageUrl'); // Debugging output

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  width: 200.0, // Adjust the width as needed
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    width: 200.0,
                                    child: const CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.grey[200],
                                    width: 200.0,
                                    child: const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
