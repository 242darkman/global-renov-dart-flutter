
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
