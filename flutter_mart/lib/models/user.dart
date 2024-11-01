class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final Map<String, dynamic> addresses;
  final List<String> savedPaymentMethods;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.addresses,
    required this.savedPaymentMethods,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phoneNumber: json['phoneNumber'],
    addresses: json['addresses'],
    savedPaymentMethods: List<String>.from(json['savedPaymentMethods']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phoneNumber': phoneNumber,
    'addresses': addresses,
    'savedPaymentMethods': savedPaymentMethods,
  };
}