//lib/screens/manage_addresses_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageAddressesScreen extends StatefulWidget {
  const ManageAddressesScreen({Key? key}) : super(key: key);

  @override
  _ManageAddressesScreenState createState() => _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends State<ManageAddressesScreen> {
  void _openAddressForm({Map<String, dynamic>? existingAddress, String? addressId}) {
    final TextEditingController streetController = TextEditingController(text: existingAddress?['street'] ?? '');
    final TextEditingController cityController = TextEditingController(text: existingAddress?['city'] ?? '');
    final TextEditingController stateController = TextEditingController(text: existingAddress?['state'] ?? '');
    final TextEditingController zipController = TextEditingController(text: existingAddress?['zip'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existingAddress != null ? "Edit Address" : "Add Address"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: streetController, decoration: const InputDecoration(labelText: 'Street')),
              TextField(controller: cityController, decoration: const InputDecoration(labelText: 'City')),
              TextField(controller: stateController, decoration: const InputDecoration(labelText: 'State')),
              TextField(controller: zipController, decoration: const InputDecoration(labelText: 'ZIP Code')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final newAddress = {
                  'street': streetController.text,
                  'city': cityController.text,
                  'state': stateController.text,
                  'zip': zipController.text,
                  'isDefault': existingAddress?['isDefault'] ?? false,
                };

                final userId = FirebaseAuth.instance.currentUser!.uid;

                if (addressId != null) {
                  // Update existing address
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('addresses')
                      .doc(addressId)
                      .update(newAddress);
                } else {
                  // Add new address
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('addresses')
                      .add(newAddress);
                }
                Navigator.of(context).pop();
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

    await batch.commit(); // Perform all updates in a single batch write
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