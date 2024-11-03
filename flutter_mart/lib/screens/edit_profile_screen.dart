import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadAvatar() async {
    if (_imageFile == null) return;

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_avatars')
            .child('${user.uid}.jpg');

        // Delete the old avatar if it exists
        try {
          await storageRef.delete();
        } catch (e) {
          // Ignore if there's no existing image to delete
          print("No previous avatar to delete: $e");
        }

        // Upload the new file
        await storageRef.putFile(_imageFile!);

        // Get the download URL
        final downloadUrl = await storageRef.getDownloadURL();

        // Update user profile with the new photo URL
        await user.updatePhotoURL(downloadUrl);

        ElegantNotification.success(
          title: const Text("Success"),
          description: const Text("Avatar updated successfully"),
        ).show(context);
      }
    } catch (e) {
      ElegantNotification.error(
        title: const Text("Error"),
        description: Text("Error uploading avatar: $e"),
      ).show(context);
    }
  }

  Future<void> _updateProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(_nameController.text);
        await user.updateEmail(_emailController.text);
        await _uploadAvatar(); // Upload the avatar if there's a new image

        ElegantNotification.success(
          title: const Text("Success"),
          description: const Text("Profile updated successfully"),
        ).show(context);
      }
    } catch (e) {
      ElegantNotification.error(
        title: const Text("Error"),
        description: Text("Error updating profile: $e"),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : (user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const AssetImage('assets/default_avatar.png'))
                as ImageProvider,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _pickImage,
              child: const Text("Change Avatar"),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}