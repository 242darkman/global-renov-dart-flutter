class Address {
  String? id;
  String street;
  String city;
  String postalCode;

  Address({required this.street, required this.city, required this.postalCode});

  String get getStreet => street;

  String get getCity => city;

  String get getPostalCode => postalCode;

  Address copyWith({
    String? street,
    String? city,
    String? postalCode,
  }) {
    return Address(
      street: street ?? this.street,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'postalCode': postalCode,
    };
  }

  static Address fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String,
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
    );
  }
}
