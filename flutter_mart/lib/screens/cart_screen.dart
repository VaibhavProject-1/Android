import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:elegant_notification/elegant_notification.dart'; // Import ElegantNotification
import '../providers/cart_provider.dart';
import '../components/cart/cart_item.dart';
import '../components/subtotal_display.dart';
import '../components/total_display.dart';
import '../components/payment_button.dart';
import '../utils/dialogs.dart';
import '../services/order_service.dart';
import '../models/order.dart' as custom_order;

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Razorpay _razorpay;
  final OrderService _orderService = OrderService();
  Map<String, String>? selectedAddress;
  String? contactPhone;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Check for saved addresses on load
    _checkForSavedAddresses();
  }

  Future<void> _checkForSavedAddresses() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .get();

    if (snapshot.docs.isEmpty) {
      _openAddressForm();
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _selectAddress() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .get();

    if (snapshot.docs.isNotEmpty) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              children: [
                ListTile(
                  title: const Text("Add New Address"),
                  leading: const Icon(Icons.add),
                  onTap: () {
                    Navigator.pop(context); // Close the modal
                    _openAddressForm();
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.docs.length,
                    itemBuilder: (context, index) {
                      final address = snapshot.docs[index];
                      return ListTile(
                        title: Text("${address['street']}, ${address['city']}"),
                        subtitle: Text("${address['state']} - ${address['zip']}"),
                        onTap: () {
                          setState(() {
                            selectedAddress = {
                              'street': address['street'] as String,
                              'city': address['city'] as String,
                              'state': address['state'] as String,
                              'zip': address['zip'] as String,
                            };
                          });
                          Navigator.pop(context); // Close the modal
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          });
    } else {
      ElegantNotification.info(
        title: const Text("No Saved Addresses"),
        description: const Text("Please add a new address."),
      ).show(context);
      _openAddressForm();
    }
  }

  Future<void> _openAddressForm() async {
    final TextEditingController streetController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController stateController = TextEditingController();
    final TextEditingController zipController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Address"),
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
                };

                final userId = FirebaseAuth.instance.currentUser!.uid;
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('addresses')
                    .add(newAddress);

                setState(() {
                  selectedAddress = newAddress;
                });

                Navigator.of(context).pop();
                ElegantNotification.success(
                  title: const Text("Address Added"),
                  description: const Text("New address added successfully."),
                ).show(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _promptForPhone() async {
    final TextEditingController phoneController = TextEditingController(text: contactPhone);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Contact Phone"),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: "Phone Number"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  contactPhone = phoneController.text;
                });
                Navigator.pop(context);
                ElegantNotification.success(
                  title: const Text("Phone Number Saved"),
                  description: const Text("Contact phone number has been updated."),
                ).show(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && selectedAddress != null && contactPhone != null) {
      final order = custom_order.Order(
        orderId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        items: cartProvider.items,
        totalAmount: cartProvider.totalPrice,
        paymentId: response.paymentId!,
        orderDate: DateTime.now(),
        paymentStatus: 'completed',
        orderStatus: 'processing',
        shippingAddress: selectedAddress!,
        contactEmail: user.email!,
        contactPhone: contactPhone!,
      );

      await _orderService.saveOrder(order);
      cartProvider.clearCart();
      showPaymentSuccessDialog(context, response.paymentId!);
    } else {
      ElegantNotification.error(
        title: const Text("Incomplete Information"),
        description: const Text("Please select an address and provide a contact phone number before proceeding."),
      ).show(context);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showPaymentErrorDialog(context, response.code.toString(), response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ElegantNotification.info(
      title: const Text("External Wallet Selected"),
      description: Text("Wallet: ${response.walletName}"),
    ).show(context);
  }

  void openCheckout(double amount) {
    if (selectedAddress == null) {
      ElegantNotification.info(
        title: const Text("Address Required"),
        description: const Text("Please select an address before proceeding."),
        background: Colors.orangeAccent.shade200, // Custom color for warning indication
        icon: const Icon(Icons.warning, color: Colors.white), // Warning icon
      ).show(context);
      return;
    }

    if (contactPhone == null || contactPhone!.isEmpty) {
      _promptForPhone();
      return;
    }

    var options = {
      'key': 'rzp_test_X7XIYABuIGXSFd',
      'amount': (amount * 100).toInt(),
      'name': 'FlutterMart',
      'description': 'Payment for items in cart',
      'prefill': {'contact': contactPhone, 'email': 'test@razorpay.com'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final subtotal = cartProvider.totalPrice;
    const deliveryCharge = 1.00;
    final total = subtotal + deliveryCharge;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: cartProvider.items.map((item) {
                  return CartItem(
                    imageUrl: item.imageUrl,
                    name: "${item.name} - ${item.variant}",
                    price: item.price,
                    quantity: 'x${item.quantity}',
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                selectedAddress != null
                    ? "Shipping to: ${selectedAddress!['street']}, ${selectedAddress!['city']}"
                    : "No Address Selected",
              ),
              subtitle: Text(
                selectedAddress != null
                    ? "${selectedAddress!['state']} - ${selectedAddress!['zip']}"
                    : "Please select or add a shipping address",
              ),
              trailing: TextButton(
                onPressed: _selectAddress,
                child: const Text("Select Address"),
              ),
            ),
            ListTile(
              title: Text("Contact Phone"),
              subtitle: Text(contactPhone ?? "Not Set"),
              trailing: TextButton(
                onPressed: _promptForPhone,
                child: const Text("Enter Phone"),
              ),
            ),
            const SizedBox(height: 16),
            SubtotalDisplay(subtotal: subtotal, deliveryCharge: deliveryCharge),
            const Divider(thickness: 1, height: 30),
            TotalDisplay(total: total),
            const SizedBox(height: 24),
            PaymentButton(onPressed: () => openCheckout(total)),
          ],
        ),
      ),
    );
  }
}