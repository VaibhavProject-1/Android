import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../components/cart/cart_item.dart';
import '../components/subtotal_display.dart';
import '../components/total_display.dart';
import '../components/payment_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Dispose of the Razorpay instance
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Text('Payment ID: ${response.paymentId}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: Text('Error: ${response.code}\nMessage: ${response.message}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('External Wallet'),
        content: Text('Wallet: ${response.walletName}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_X7XIYABuIGXSFd', // Replace with your Razorpay API Key
      'amount': 961 * 100, // Amount in smallest currency unit
      'name': 'FlutterMart',
      'description': 'Payment for items in cart',
      'prefill': {
        'contact': '8888888888',
        'email': 'test@razorpay.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = 8.61; // Example subtotal
    double deliveryCharge = 1.00; // Example delivery charge
    double total = subtotal + deliveryCharge;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  CartItem(
                    imageUrl: 'https://via.placeholder.com/80',
                    name: 'Donut',
                    price: 2.97,
                    quantity: 'R 3 A',
                  ),
                  CartItem(
                    imageUrl: 'https://via.placeholder.com/80',
                    name: 'Peas',
                    price: 1.64,
                    quantity: 'R 50 A',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SubtotalDisplay(subtotal: subtotal, deliveryCharge: deliveryCharge),
            const Divider(thickness: 1, height: 30),
            TotalDisplay(total: total),
            const SizedBox(height: 24),
            PaymentButton(onPressed: openCheckout),
          ],
        ),
      ),
    );
  }
}