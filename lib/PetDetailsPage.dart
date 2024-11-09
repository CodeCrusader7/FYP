import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PetDetailsPage extends StatefulWidget {
  final Map<String, String> pet;
  final void Function(Map<String, String> pet) onSave;

  const PetDetailsPage({super.key, required this.pet, required this.onSave});

  @override
  _PetDetailsPageState createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _weightController = TextEditingController();
  final _colorController = TextEditingController();
  final _breedController = TextEditingController();
  String _category = 'Cat';
  String _gender = 'Male';
  String _weightUnit = 'kg';
  bool _isOtherCategory = false;

  @override
  void initState() {
    super.initState();
    if (widget.pet['imagePath'] != null &&
        widget.pet['imagePath']!.isNotEmpty) {
      _image = File(widget.pet['imagePath']!);
    }
    _nameController.text = widget.pet['name'] ?? '';
    _category = widget.pet['type'] ?? 'Cat';
    _ageController.text = widget.pet['age'] ?? '';
    _gender = widget.pet['gender'] ?? 'Male';
    _weightController.text = widget.pet['weight'] ?? '';
    _weightUnit = widget.pet['weightUnit'] ?? 'kg';
    _colorController.text = widget.pet['color'] ?? '';
    _breedController.text = widget.pet['breed'] ?? '';
    _isOtherCategory = _category == 'Other';
    if (_isOtherCategory) {
      _typeController.text = widget.pet['type'] ?? '';
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _savePet() {
    if (_formKey.currentState!.validate()) {
      Map<String, String> updatedPet = {
        'name': _nameController.text,
        'type': _isOtherCategory ? _typeController.text : _category,
        'age': _ageController.text,
        'gender': _gender,
        'weight': _weightController.text,
        'weightUnit': _weightUnit,
        'color': _colorController.text,
        'breed': _breedController.text,
      };
      if (_image != null) {
        updatedPet['imagePath'] = _image!.path;
      }
      widget.onSave(updatedPet);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _weightController.dispose();
    _colorController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePet,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_image != null) Image.file(_image!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: const Icon(Icons.photo_library),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: const Icon(Icons.camera_alt),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: <String>['Cat', 'Dog', 'Bird', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue!;
                    _isOtherCategory = _category == 'Other';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              if (_isOtherCategory)
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Specify Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please specify the category';
                    }
                    return null;
                  },
                ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: <String>['Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a weight';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _weightUnit,
                decoration: const InputDecoration(labelText: 'Weight Unit'),
                items: <String>['kg', 'lbs']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _weightUnit = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a weight unit';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Color'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a color';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Breed'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a breed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePet,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
