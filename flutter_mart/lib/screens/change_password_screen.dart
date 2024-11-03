import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/stacked_options.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _changePassword() async {
    try {
      final user = _auth.currentUser;
      final cred = EmailAuthProvider.credential(
          email: user!.email!, password: _currentPasswordController.text);

      // Reauthenticate user before updating password
      await user.reauthenticateWithCredential(cred);

      // Update password
      await user.updatePassword(_newPasswordController.text);

      // Show success notification
      ElegantNotification.success(
        width: 360,
        isDismissable: true,
        stackedOptions: StackedOptions(
          key: 'top',
          type: StackedType.same,
          itemOffset: const Offset(-5, -5),
        ),
        title: const Text('Password Updated'),
        description: const Text('Your password was updated successfully.'),
        onDismiss: () {
          // Additional actions upon dismissal if needed
        },
      ).show(context);
    } catch (e) {
      // Show error notification
      ElegantNotification.error(
        width: 360,
        isDismissable: true,
        stackedOptions: StackedOptions(
          key: 'topRight',
          type: StackedType.below,
          itemOffset: const Offset(0, 5),
        ),
        title: const Text('Error'),
        description: Text("Error updating password: $e"),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Current Password"),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "New Password"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text("Update Password"),
            ),
          ],
        ),
      ),
    );
  }
}