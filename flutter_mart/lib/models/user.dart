class UserModel {
  final String id;
  String name;
  String email;
  String? phoneNumber;
  List<Map<String, String>> addresses;  // List of address objects, each with details like street, city, etc.
  List<Map<String, dynamic>> savedPaymentMethods;  // Payment method details like type, last4, expiry date

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    List<Map<String, String>>? addresses,
    List<Map<String, dynamic>>? savedPaymentMethods,
  })  : addresses = addresses ?? [],
        savedPaymentMethods = savedPaymentMethods ?? [];

  // Factory constructor to create a UserModel from JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phoneNumber: json['phoneNumber'],
    addresses: (json['addresses'] as List<dynamic>?)
        ?.map((address) => Map<String, String>.from(address))
        .toList() ??
        [],
    savedPaymentMethods: (json['savedPaymentMethods'] as List<dynamic>?)
        ?.map((method) => Map<String, dynamic>.from(method))
        .toList() ??
        [],
  );

  // Convert UserModel to JSON for saving in Firestore or Realtime Database
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'addresses': addresses,
    'savedPaymentMethods': savedPaymentMethods,
  };

  // Method to update user's personal information
  void updatePersonalInfo({String? newName, String? newPhoneNumber}) {
    if (newName != null) name = newName;
    if (newPhoneNumber != null) phoneNumber = newPhoneNumber;
  }

  // Method to add or update an address
  void addOrUpdateAddress(Map<String, String> address) {
    // Add logic to prevent duplicate addresses, or update existing ones based on certain keys
    addresses.add(address);
  }

  // Method to remove an address by index or identifier
  void removeAddress(int index) {
    if (index >= 0 && index < addresses.length) {
      addresses.removeAt(index);
    }
  }

  // Method to add a saved payment method
  void addPaymentMethod(Map<String, dynamic> paymentMethodDetails) {
    // Ensure there's no duplicate based on an identifier, like 'last4' or 'token'
    bool exists = savedPaymentMethods.any((method) =>
    method['token'] == paymentMethodDetails['token']); // Adjust 'token' to any unique identifier you use

    if (!exists) {
      savedPaymentMethods.add(paymentMethodDetails);
    }
  }


  // Method to remove a saved payment method by token
  void removePaymentMethod(String paymentMethodToken) {
    savedPaymentMethods.remove(paymentMethodToken);
  }
}