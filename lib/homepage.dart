import 'package:flutter/material.dart';
import 'package:lostnfound/Utils/app_drawer.dart';
import 'package:lostnfound/Utils/dialog_box.dart';
import 'package:lostnfound/Utils/elevated_button.dart';
import 'package:lostnfound/pages/found_page.dart';
import 'package:lostnfound/pages/lost_page.dart';
import 'package:lostnfound/pages/upload_item_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> navigateToUploadPage(bool isLostItem) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadItemPage(isLostItem: isLostItem),
      ),
    );
  }

  Future<void> showItemTypeDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ItemTypeDialog(
          onItemSelected: (bool isLostItem) {
            navigateToUploadPage(
                isLostItem); // Trigger navigation after selection
          },
          title: const Text('ItemType'),
          content: const Text('Is this item lost or found?'),
          button2name: 'Found',
          button1name: 'Lost',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.search), text: 'Lost Items'),
            Tab(icon: Icon(Icons.check_circle), text: 'Found Items'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    MediaQuery.of(context).size.width * 0.4, // Restrict width
              ),
              child: ElevatedButtonWidget(
                text: "Upload New",
                onPressed:
                    showItemTypeDialog, // Invoke the separate dialog widget
                icon: Icons.add,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LostPage(),
          FoundPage(),
        ],
      ),
      drawer: const AppDrawer(),
    );
  }
}
