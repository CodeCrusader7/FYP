 import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'vet_model.dart';

class AddVetPage extends StatefulWidget {
  final Function(VetModel) onSave;
  final VetModel? vet;

  const AddVetPage({super.key, required this.onSave, this.vet});

  @override
  _AddVetPageState createState() => _AddVetPageState();
}

class _AddVetPageState extends State<AddVetPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _openingTimeController;
  late TextEditingController _closingTimeController;
  late TextEditingController _websiteController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  File? _selectedImage;
  bool _isEmergencyAvailable = false;

  get _descriptionController => null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vet?.name ?? '');
    _addressController = TextEditingController(text: widget.vet?.address ?? '');
    _openingTimeController = TextEditingController(
        text: widget.vet?.openingTime.split(' - ').first ?? '');
    _closingTimeController = TextEditingController(
        text: widget.vet?.openingTime.split(' - ').last ?? '');
    _websiteController = TextEditingController(text: widget.vet?.website ?? '');
    _phoneController = TextEditingController(text: widget.vet?.phone ?? '');
    _emailController = TextEditingController(text: widget.vet?.email ?? '');
    _isEmergencyAvailable = widget.vet?.isEmergencyAvailable ?? false;
    if (widget.vet != null && widget.vet!.imagePath.isNotEmpty) {
      _selectedImage = File(widget.vet!.imagePath);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      var descriptionController;
      final newVet = VetModel(
        description: descriptionController.text,
        name: _nameController.text,
        address: _addressController.text,
        openingTime:
            '${_openingTimeController.text} - ${_closingTimeController.text}',
        website: _websiteController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        imagePath: _selectedImage?.path ?? '',
        isEmergencyAvailable: _isEmergencyAvailable,
      );
      widget.onSave(newVet);
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickOpeningTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _openingTimeController.text = time.format(context);
      });
    }
  }

  Future<void> _pickClosingTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _closingTimeController.text = time.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vet == null ? 'Add New Vet' : 'Edit Vet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  height: 200,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
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
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _openingTimeController,
                decoration: const InputDecoration(labelText: 'Opening Time'),
                readOnly: true,
                onTap: _pickOpeningTime,
              ),
              TextFormField(
                controller: _closingTimeController,
                decoration: const InputDecoration(labelText: 'Closing Time'),
                readOnly: true,
                onTap: _pickClosingTime,
              ),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(labelText: 'Website'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a website';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  // Basic email validation
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Emergency Available'),
                  Switch(
                    value: _isEmergencyAvailable,
                    onChanged: (value) {
                      setState(() {
                        _isEmergencyAvailable = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.vet == null ? 'Add Vet' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}