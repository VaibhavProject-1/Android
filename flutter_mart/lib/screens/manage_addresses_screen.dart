import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageAddressesScreen extends StatefulWidget {
  const ManageAddressesScreen({Key? key}) : super(key: key);

  @override
  _ManageAddressesScreenState createState() => _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends State<ManageAddressesScreen> {
  void _openAddressForm({Map<String, dynamic>? existingAddress, String? addressId}) {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController streetController = TextEditingController(text: existingAddress?['street'] ?? '');
    final TextEditingController cityController = TextEditingController(text: existingAddress?['city'] ?? '');
    final TextEditingController stateController = TextEditingController(text: existingAddress?['state'] ?? '');
    final TextEditingController zipController = TextEditingController(text: existingAddress?['zip'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingAddress != null ? "Edit Address" : "Add Address"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: streetController,
                  decoration: const InputDecoration(labelText: 'Street'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Street is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$'))],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'City is required';
                    } else if (RegExp(r'\d').hasMatch(value)) {
                      return 'City cannot contain numbers';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$'))],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'State is required';
                    } else if (RegExp(r'\d').hasMatch(value)) {
                      return 'State cannot contain numbers';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: zipController,
                  decoration: const InputDecoration(labelText: 'ZIP Code'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Ensure numeric-only input
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ZIP Code is required';
                    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'ZIP Code must be numeric';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final newAddress = {
                    'street': streetController.text,
                    'city': cityController.text,
                    'state': stateController.text,
                    'zip': zipController.text,
                    'isDefault': existingAddress?['isDefault'] ?? false,
                  };

                  final userId = FirebaseAuth.instance.currentUser!.uid;

                  if (addressId != null) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('addresses')
                        .doc(addressId)
                        .update(newAddress);
                  } else {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('addresses')
                        .add(newAddress);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _setDefaultAddress(String addressId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final addresses = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var address in addresses.docs) {
      batch.update(address.reference, {'isDefault': address.id == addressId});
    }

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Addresses")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('addresses')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No addresses found."));
          }

          final addresses = snapshot.data!.docs;
          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              final data = address.data() as Map<String, dynamic>;
              final isDefault = data.containsKey('isDefault') ? data['isDefault'] : false;

              return ListTile(
                title: Text(data['street']),
                subtitle: Text("${data['city']}, ${data['state']} - ${data['zip']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        isDefault ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isDefault ? Colors.green : Colors.grey,
                      ),
                      onPressed: () => _setDefaultAddress(address.id),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openAddressForm(
                        existingAddress: data,
                        addressId: address.id,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('addresses')
                            .doc(address.id)
                            .delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddressForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}