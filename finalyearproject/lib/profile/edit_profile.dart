import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:math';
import 'user_profile_provider.dart';
import 'profile_picture_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  late TextEditingController _fullNameController;
  late TextEditingController _bioController;
  late TextEditingController _addressController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _birthdayController;
  String? _selectedGender;
  DateTime? _selectedDate;
  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    _displayNameController = TextEditingController(text: userProfileProvider.displayName);
    _fullNameController = TextEditingController(text: userProfileProvider.fullName);
    _bioController = TextEditingController(text: userProfileProvider.bio);
    _addressController = TextEditingController(text: userProfileProvider.address);
    _phoneNumberController = TextEditingController(text: userProfileProvider.phoneNumber);
    _birthdayController = TextEditingController(text: userProfileProvider.birthday);
    _selectedGender = userProfileProvider.gender.isNotEmpty ? userProfileProvider.gender : null;
    _selectedDate = DateTime.tryParse(userProfileProvider.birthday);
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);

      // Simulate a delay of 1-2 seconds
      await Future.delayed(Duration(seconds: Random().nextInt(2) + 1));

      await userProfileProvider.updateProfile(
        displayName: _displayNameController.text,
        fullName: _fullNameController.text,
        bio: _bioController.text,
        address: _addressController.text,
        phoneNumber: _phoneNumberController.text,
        birthday: _birthdayController.text,
        gender: _selectedGender ?? '',
        profilePicture: _image,
      );

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context, {
        'displayName': _displayNameController.text,
        'fullName': _fullNameController.text,
        'bio': _bioController.text,
        'address': _addressController.text,
        'phoneNumber': _phoneNumberController.text,
        'birthday': _birthdayController.text,
        'gender': _selectedGender ?? '',
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _birthdayController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String validatorMessage,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              controller.clear();
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 243, 224, 1), // Use the desired background color
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfilePicturePicker(
                      image: _image,
                      onImageSelected: (File image) {
                        setState(() {
                          _image = image;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _displayNameController,
                      labelText: 'Username',
                      validatorMessage: 'Please enter your username',
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _fullNameController,
                      labelText: 'Full Name',
                      validatorMessage: 'Please enter your full name',
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _bioController,
                      labelText: 'Bio',
                      validatorMessage: 'Please enter your bio',
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _addressController,
                      labelText: 'Address',
                      validatorMessage: 'Please enter your address',
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _phoneNumberController,
                      labelText: 'Phone Number',
                      validatorMessage: 'Please enter your phone number',
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _birthdayController,
                      decoration: InputDecoration(
                        labelText: 'Birthday',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your birthday';
                        }
                        return null;
                      },
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: const [
                        DropdownMenuItem(
                          value: null,
                          child: Text('Choose your gender'),
                        ),
                        DropdownMenuItem(
                          value: 'Male',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text('Female'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
