import 'address_model.dart';

class Intervention {
  int id;
  String status;
  String date;
  String customer;
  Address address;

  Intervention({
    required this.id,
    required this.status,
    required this.date,
    required this.customer,
    required this.address,
  });

  factory Intervention.fromJson(Map<String, dynamic> json) {
    try {
      return Intervention(
        id: json['id'] as int,
        status: json['status'] as String,
        date: json['date'] as String,
        customer: json['customer'] as String,
        address: Address.fromJson(json['address'] as Map<String, dynamic>),
      );
    } catch (_) {
      throw const FormatException('Failed to load intervention');
    }
  }
}
