import 'package:flutter/material.dart';
import 'dart:io';
import 'PetDetailsPage.dart';
import 'PetProfilePage.dart';

void main() {
  runApp(PetListApp());
}

class PetListApp extends StatelessWidget {
  const PetListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PetListPage(),
    );
  }
}

class PetListPage extends StatefulWidget {
  const PetListPage({super.key});

  @override
  _PetListPageState createState() => _PetListPageState();
}

class _PetListPageState extends State<PetListPage> {
  List<Map<String, String>> pets = [];

  void _addPet(Map<String, String> pet) {
    setState(() {
      pets.add(pet);
    });
  }

  void _editPet(int index, Map<String, String> updatedPet) {
    setState(() {
      pets[index] = updatedPet;
    });
  }

  void _deletePet(int index) {
    setState(() {
      pets.removeAt(index);
    });
  }

  void _navigateToPetDetails({required bool isNew, int? index}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetDetailsPage(
          pet: isNew ? {} : pets[index!],
          onSave: (updatedPet) {
            if (isNew) {
              _addPet(updatedPet);
            } else {
              _editPet(index!, updatedPet);
            }
          },
        ),
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Profile to Edit'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: pets.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(pets[index]['name'] ?? 'No Name'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _navigateToPetDetails(isNew: false, index: index);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Profile to Delete'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: pets.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(pets[index]['name'] ?? 'No Name'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deletePet(index);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditDialog,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4.0,
            child: ListTile(
              leading: pets[index]['imagePath'] != null
                  ? Image.file(
                      File(pets[index]['imagePath']!),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.pets),
              title: Text(pets[index]['name'] ?? 'No Name'),
              subtitle: Text(pets[index]['type'] ?? 'No Category'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetProfilePage(
                      pet: pets[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToPetDetails(isNew: true),
        child: const Icon(Icons.add),
      ),
    );
  }

  Null get newMethod => null;
}
