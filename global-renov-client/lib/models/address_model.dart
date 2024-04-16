class Address {
  String street;
  String city;
  String postalCode;

  Address({required this.street, required this.city, required this.postalCode});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String,
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
    );
  }
}
