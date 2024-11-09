import 'package:flutter/material.dart';
import 'dart:io';

class PetProfilePage extends StatelessWidget {
  final Map<String, String> pet;

  const PetProfilePage({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pet['imagePath'] != null && pet['imagePath']!.isNotEmpty)
              Image.file(
                File(pet['imagePath']!),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: Icon(
                  Icons.pets,
                  size: 100,
                  color: Colors.grey[400],
                ),
              ),
            const SizedBox(height: 16),
            Text(
              pet['name'] ?? 'Pet Name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              pet['type'] ?? 'Pet Type',
              style: const TextStyle(fontSize: 18, color: Colors.purple),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoCard('Age', pet['age'] ?? ''),
                _buildInfoCard('Gender', pet['gender'] ?? ''),
                _buildInfoCard('Weight', pet['weight'] ?? ''),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Additional Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAdditionalInfo('Color', pet['color'] ?? ''),
            _buildAdditionalInfo('Breed', pet['breed'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String info) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.purple),
            ),
            const SizedBox(height: 8),
            Text(
              info,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo(String title, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            info,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
