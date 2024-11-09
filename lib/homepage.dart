import 'package:flutter/material.dart';
import 'package:flutter_application_1/drawer.dart';
import 'PetListPage.dart';
import 'appointment_schedules.dart';
import 'online_consultation.dart';
import 'emergency.dart';
import 'vet_profile_page.dart'; // Import the VetProfilePage
import 'add_vet_page.dart';
import 'vet_model.dart';
import 'list_of_pets_with_appointment.dart'; // Import the new page
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<VetModel> vets = [];

  void _addVet(VetModel vet) {
    setState(() {
      vets.add(vet);
    });
  }

  void _updateVet(int index, VetModel updatedVet) {
    setState(() {
      vets[index] = updatedVet;
    });
  }

  void _deleteVet(int index) {
    setState(() {
      vets.removeAt(index);
    });
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Profile to Delete'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: vets.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(vets[index].name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteVet(index);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVetPage(
          onSave: (updatedVet) => _updateVet(index, updatedVet),
          vet: vets[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VetConnect'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddVetPage(onSave: _addVet),
                ),
              );
            },
            child: Text(
              'Add profile',
              style: TextStyle(
                  color: Color.fromARGB(255, 207, 82, 230), fontSize: 16),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(
        email: "user@example.com", // Replace with dynamic data
        profileImageUrl: "https://www.example.com/profile.jpg",
        onLogout: () {}, // Replace with dynamic data
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade100, Colors.orange.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Take care of pet\'s health\nyour pet is important',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryButton(
                  context,
                  Icons.schedule,
                  'appointment\nschedules',
                  AppointmentSchedulesPage(),
                ),
                SizedBox(width: 10),
                _buildCategoryButton(
                  context,
                  Icons.chat,
                  'online\nconsultation',
                  OnlineConsultationPage(),
                ),
                SizedBox(width: 10),
                _buildCategoryButton(
                  context,
                  Icons.pets,
                  'pet\nprofiles',
                  ListOfPetsWithAppointmentPage(vetId: '',), // Navigate to the new page
                ),
                SizedBox(width: 10),
                _buildCategoryButton(
                  context,
                  Icons.local_hospital,
                  'emergency',
                  EmergencyPage(),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Veterinary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: _showDeleteDialog,
            child: Text(
              'Delete profile',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 0, 0), fontSize: 16),
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: vets.length,
            itemBuilder: (context, index) {
              return _buildVeterinaryCard(context, vets[index], index);
            },
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home, size: 24),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.calendar_today, size: 22),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.chat, size: 24),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person, size: 26),
      //       label: '',
      //     ),
      //       // ],
      //       selectedItemColor: Colors.purple,
      //       unselectedItemColor: Colors.grey,
      //       showSelectedLabels: false,
      //       showUnselectedLabels: false,
      //     ),
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, IconData icon, String label, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(icon),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            },
            iconSize: 50,
          ),
          SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildVeterinaryCard(BuildContext context, VetModel vet, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VetProfilePage(
              vet: vet,
              onUpdate: (updatedVet) => _updateVet(index, updatedVet), onBookAppointment: () {  },
            ),
          ),
        );
      },
      onLongPress: () {
        _showEditDialog(index);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade100, Colors.purple.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipOval(
                child:
                    vet.imagePath.isNotEmpty && File(vet.imagePath).existsSync()
                        ? Image.file(
                            File(vet.imagePath),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/default_vet_image.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
              ),
              SizedBox(height: 8),
              Text(
                'Dr. ${vet.name}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, size: 16),
                  SizedBox(width: 4),
                  Text(
                    vet.address,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
