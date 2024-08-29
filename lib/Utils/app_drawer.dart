import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const AppDrawerHeader(),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () => Navigator.pop(context),
          ),
          _createDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () => Navigator.pop(context),
          ),
          _createDrawerItem(
            icon: Icons.help,
            text: 'Help & Support',
            onTap: () => Navigator.pop(context),
          ),
          _createDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  ListTile _createDrawerItem({
    required IconData icon,
    required String text,
    required void Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}

class AppDrawerHeader extends StatelessWidget {
  const AppDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/profile_picture.png'),
          ),
          SizedBox(height: 10),
          Text(
            'User Name',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            'user@example.com',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
