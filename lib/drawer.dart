import 'package:flutter/material.dart';
import 'package:flutter_application_1/PetListPage.dart';
import 'online_consultation.dart';

class MyDrawer extends StatelessWidget {
  final String email; // The user's email
  final String profileImageUrl; // The user's profile image URL
  final VoidCallback onLogout; // Logout function

  MyDrawer({
    required this.email,
    required this.profileImageUrl,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(email),
            accountName: Text(
              "Welcome!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple[500], // Drawer header background color
            ),
          ),
          ListTile(
            leading: Icon(Icons.pets),
            title: Text('Pet Profiles'),
            onTap: () {
              // Navigate to pet profiles screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PetListApp()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              onLogout(); // Trigger the logout callback
            },
          ),
        ],
      ),
    );
  }
}
