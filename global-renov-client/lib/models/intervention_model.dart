import 'package:global_renov/utils/logger.dart';

import 'address_model.dart';

class Intervention {
  String id;
  String status;
  String date;
  String customer;
  Address address;
  String description;

  Intervention({
    required this.id,
    required this.status,
    required this.date,
    required this.customer,
    required this.address,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'date': date,
      'customer': customer,
      'address': address.toJson(),
      'description': description
    };
  }

  factory Intervention.fromJson(Map<String, dynamic> json) {
    try {
      return Intervention(
        id: json['id'] as String,
        status: json['status'] as String,
        date: json['date'] as String,
        customer: json['customer'] as String,
        address: Address.fromJson(json['address'] as Map<String, dynamic>),
        description: json['description'] as String,
      );
    } catch (e) {
      log.severe('Failed to load intervention $e');
      throw const FormatException('Failed to load intervention');
    }
  }
}
