import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfileProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String displayName = '';
  String fullName = '';
  String bio = '';
  String address = '';
  String phoneNumber = '';
  String birthday = '';
  String gender = '';
  String profileImageUrl = '';

  UserProfileProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        fetchUserData();
      } else {
        resetUserData();
      }
    });
  }

  Future<void> updateProfile({
    required String displayName,
    required String fullName,
    required String bio,
    required String address,
    required String phoneNumber,
    required String birthday,
    required String gender,
    File? profilePicture,
  }) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        String? imageUrl;
        if (profilePicture != null) {
          imageUrl = await _uploadProfilePicture(user.uid, profilePicture);
        }

        await _firestore.collection('users').doc(user.uid).set({
          'displayName': displayName,
          'fullName': fullName,
          'bio': bio,
          'address': address,
          'phoneNumber': phoneNumber,
          'birthday': birthday,
          'gender': gender,
          'profileImageUrl': imageUrl ?? profileImageUrl,
        });

        this.displayName = displayName;
        this.fullName = fullName;
        this.bio = bio;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.birthday = birthday;
        this.gender = gender;
        if (imageUrl != null) {
          this.profileImageUrl = imageUrl;
        }

        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          displayName = userDoc['displayName'];
          fullName = userDoc['fullName'];
          bio = userDoc['bio'];
          address = userDoc['address'];
          phoneNumber = userDoc['phoneNumber'];
          birthday = userDoc['birthday'];
          gender = userDoc['gender'];
          profileImageUrl = userDoc['profileImageUrl'];
          notifyListeners();
        } else {
          // Set default values for new user
          resetUserData();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<String> _uploadProfilePicture(String uid, File profilePicture) async {
    try {
      final Reference storageRef = _storage.ref().child('profile_pictures').child('$uid.jpg');
      final UploadTask uploadTask = storageRef.putFile(profilePicture);
      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return '';
    }
  }

  void resetUserData() {
    displayName = '';
    fullName = '';
    bio = '';
    address = '';
    phoneNumber = '';
    birthday = '';
    gender = '';
    profileImageUrl = '';
    notifyListeners();
  }

  void loadUserData(String email) {}
}
