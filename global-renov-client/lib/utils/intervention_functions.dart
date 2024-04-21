import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Translates the given [status] string to its corresponding French translation.
///
/// The [status] parameter should be one of the following strings:
/// - 'scheduled': Translates to 'Programmée'.
/// - 'canceled': Translates to 'Annulée'.
/// - 'closed': Translates to 'Clôturée'.
/// - Any other string: Translates to 'Inconnu'.
///
/// Returns the translated string.
String translateStatus(String status) {
  switch (status) {
    case 'scheduled':
      return 'Programmée';
    case 'canceled':
      return 'Annulée';
    case 'closed':
      return 'Clôturée';
    default:
      return 'Inconnu';
  }
}

/// Returns a `Color` based on the given [status] string.
///
/// The [status] parameter should be one of the following strings:
/// - 'scheduled': Returns a color with the hexadecimal value 0xFF51BEE0.
/// - 'canceled': Returns a color with the hexadecimal value 0xFF7D949B.
/// - Any other string: Returns a color with the hexadecimal value 0xFF84CD8D.
///
/// Returns a `Color` object representing the corresponding color.
Color getStatusColor(String status) {
  switch (status) {
    case "scheduled":
      return const Color(0xFF51BEE0);
    case "canceled":
      return const Color(0xFF7D949B);
    default:
      return const Color(0xFF84CD8D);
  }
}

/// Formats the given [input] DateTime object into a string with the specified [outputFormat].
///
/// The [input] parameter can be either a `String` or a `DateTime` object. If it is a `String`,
/// it is parsed into a `DateTime` object using the provided [inputFormat]. If no [inputFormat]
/// is provided, the default date format is used.
///
/// The [outputFormat] parameter specifies the format of the output string. By default, it is set to
/// 'dd/MM/yyyy', which represents the day, month, and year in a two-digit format.
///
/// This function throws a `FormatException` if the [input] is not a `String` or a `DateTime` object.
///
/// Returns the formatted date and time as a `String`.

//DEBUT,,,,,,,,,,,,,,,,,,,,,,,,,,,,
// String formatDateTime(dynamic input,
//     {String inputFormat = '', String outputFormat = 'dd/MM/yyyy'}) {
//   if (input is! String && input is! DateTime) {
//     throw const FormatException('Input must be a String or DateTime');
//   }

//   if (input is String) {
//     return formatStringDate(input, inputFormat, outputFormat);
//   }

//   return DateFormat(outputFormat).format(input);
// }

// fin,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
String formatDateTime(dynamic input,
    {String inputFormat = '', String outputFormat = 'dd/MM/yyyy'}) {
  if (input is! String && input is! DateTime) {
    throw const FormatException('Input must be a String or DateTime');
  }

  if (input is String) {
    // Vérifier si le format d'entrée est "yyyy-MM-dd"
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(input)) {
      return formatStringDate(input, 'yyyy-MM-dd', outputFormat);
    }
    // Sinon, supposer que le format d'entrée est "dd/MM/yyyy"
    else {
      return formatStringDate(input, 'dd/MM/yyyy', outputFormat);
    }
  }

  return DateFormat(outputFormat).format(input);
}


// Formats the given [date] String into a DateTime object using the provided [inputFormat]. If [inputFormat] is empty, the default format is used.
// Then, formats the parsed date into a string with the specified [outputFormat] and returns it.
String formatStringDate(String date, String inputFormat, String outputFormat) {
  DateTime parsedDate;
  if (inputFormat.isNotEmpty) {
    DateFormat formatter = DateFormat(inputFormat);
    parsedDate = formatter.parse(date);
  } else {
    parsedDate = DateTime.parse(date);
  }
  return DateFormat(outputFormat).format(parsedDate);
}
