import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/services.dart';
import '../components/cart_item_tile.dart';
import '../providers/cart_provider.dart';
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
  final TextEditingController _couponController = TextEditingController();
  double discountAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _checkForSavedAddresses();

    // Listen for changes in the cart provider to reset discount if necessary
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addListener(() {
      if (cartProvider.totalPrice < 200) {
        setState(() {
          discountAmount = 0.0; // Reset discount if total is below ₹200
        });
      }
    });
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
                    Navigator.pop(context);
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
                        subtitle: Text(
                            "${address['state']} - ${address['zip']}"),
                        onTap: () {
                          setState(() {
                            selectedAddress = {
                              'street': address['street'] as String,
                              'city': address['city'] as String,
                              'state': address['state'] as String,
                              'zip': address['zip'] as String,
                            };
                          });
                          Navigator.pop(context);
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
    final _formKey = GlobalKey<FormState>();
    final TextEditingController streetController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController stateController = TextEditingController();
    final TextEditingController zipController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Address"),
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'City is required';
                    }
                    if (RegExp(r'[0-9]').hasMatch(value)) {
                      return 'City should not contain numbers';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'State is required';
                    }
                    if (RegExp(r'[0-9]').hasMatch(value)) {
                      return 'State should not contain numbers';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: zipController,
                  decoration: const InputDecoration(labelText: 'ZIP Code'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ZIP Code is required';
                    } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                      return 'ZIP Code must be 6 digits';
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
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _promptForPhone() async {
    final TextEditingController phoneController = TextEditingController(
        text: contactPhone);
    final _phoneFormKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Contact Phone"),
          content: Form(
            key: _phoneFormKey,
            child: TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: "Phone Number"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                  return 'Phone number must be 10 digits';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (_phoneFormKey.currentState!.validate()) {
                  setState(() {
                    contactPhone = phoneController.text;
                  });
                  Navigator.pop(context);
                  ElegantNotification.success(
                    title: const Text("Phone Number Saved"),
                    description: const Text(
                        "Contact phone number has been updated."),
                  ).show(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _applyCoupon() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    if (_couponController.text.trim() == "DISCOUNT10") {
      if(cartProvider.totalPrice >= 200){
        setState(() {
          discountAmount = 10.0;
        });
        ElegantNotification.success(
          title: const Text("Coupon Applied"),
          description: const Text("Discount of ₹10 applied to your order."),
        ).show(context);
      } else {
        // If the total drops below ₹200 after removing items, reset discount

        ElegantNotification.error(
          title: const Text("Invalid Coupon"),
          description: const Text("The coupon code is invalid."),
        ).show(context);
      }
    } else {
      ElegantNotification.error(
        title: const Text("Invalid Coupon"),
        description: const Text("The coupon code is invalid."),
      ).show(context);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && selectedAddress != null && contactPhone != null) {
      final order = custom_order.Order(
        orderId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        items: cartProvider.items,
        totalAmount: cartProvider.totalPrice - discountAmount,
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
        description: const Text(
            "Please select an address and provide a contact phone number before proceeding."),
      ).show(context);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showPaymentErrorDialog(
        context, response.code.toString(), response.message!);
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
        background: Colors.orangeAccent.shade200,
        icon: const Icon(Icons.warning, color: Colors.white),
      ).show(context);
      return;
    }

    if (contactPhone == null || contactPhone!.isEmpty) {
      _promptForPhone();
      return;
    }

    var options = {
      'key': 'rzp_test_X7XIYABuIGXSFd',
      'amount': ((amount - discountAmount) * 100).toInt(),
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
    const deliveryCharge = 30.00;
    final total = subtotal + deliveryCharge - discountAmount;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 400, // Set fixed height to prevent overflow issues
                child: ListView(
                  shrinkWrap: true,
                  children: cartProvider.items.map((item) {
                    return CartItemTile(
                      imageUrl: item.imageUrl,
                      name: "${item.name} - ${item.variant}",
                      price: item.price,
                      quantity: item.quantity,
                      onIncreaseQuantity: () {
                        cartProvider.updateItemQuantity(item.productId, item.quantity + 1);
                      },
                      onDecreaseQuantity: () {
                        if (item.quantity > 1) {
                          cartProvider.updateItemQuantity(item.productId, item.quantity - 1);
                        } else {
                          cartProvider.removeItem(item.productId);
                        }
                      },
                      onRemove: () {
                        cartProvider.removeItem(item.productId);
                      },
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
              TextFormField(
                controller: _couponController,
                decoration: const InputDecoration(labelText: 'Enter Coupon Code'),
              ),
              TextButton(
                onPressed: _applyCoupon,
                child: const Text("Apply Coupon"),
              ),
              SubtotalDisplay(subtotal: subtotal, deliveryCharge: deliveryCharge),
              const Divider(thickness: 1, height: 30),
              TotalDisplay(total: total),
              const SizedBox(height: 24),
              PaymentButton(onPressed: () => openCheckout(total)),
            ],
          ),
        ),
      ),
    );
  }
}