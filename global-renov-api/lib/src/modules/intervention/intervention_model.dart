import 'package:global_renov_api/src/modules/address/address_model.dart';

import 'package:global_renov_api/src/utils/exception/invalid_status_exception.dart';

class Intervention {
  String? id;
  String status;
  String date;
  String customer;
  Address address;
  String description;
  static const List<String> validStatuses = ['scheduled', 'closed', 'canceled'];

  Intervention(
      {this.id,
      required this.status,
      required this.date,
      required this.customer,
      required this.address,
      required this.description}) {
    if (!validStatuses.contains(status)) {
      throw InvalidStatusException(
          'Invalid status: $status. Status must be one of $validStatuses.');
    }
  }

  String get getStatus => status;

  String get getDate => date;

  String get getCustomer => customer;

  Address get getAddress => address;

  String get getDescription => description;

  Intervention copyWith(
      {String? id,
      String? status,
      String? date,
      String? customer,
      Address? address,
      String? description}) {
    return Intervention(
        id: id ?? this.id,
        status: status ?? this.status,
        date: date ?? this.date,
        customer: customer ?? this.customer,
        address: address ?? this.address,
        description: description ?? this.description);
  }

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

  static Intervention fromJson(Map<String, dynamic> json) {
    return Intervention(
      id: json['id'] as String?,
      status: json['status'] as String,
      date: json['date'] as String,
      customer: json['customer'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      description: json['description'] as String,
    );
  }
}
