

enum CaptureType{
  delayed,
  immediate
}

enum ForceEntryModeType {
  rfid('RFID'),
  keyed('Keyed', 'Manual key entry'),
  manual('Manual', 'Reading of embossing or OCR of printed data either at time of transaction or after the event.'),
  file('File', 'Account data on file'),
  scanned('Scanned', 'Scanned by a bar code reader.'),
  magStripe('MagStripe', 'Magnetic stripe'),
  icc('ICC'),
  synchronousIcc('SynchronousICC', 'Contact ICC (synchronous)'),
  tapped('Tapped', 'Contactless card reader Magnetic Stripe'),
  contactless('Contactless', 'Contactless card reader conform to ISO 14443'),
  checkReader('CheckReader', 'Check Reader');

  final String value;
  final String? description;

  const ForceEntryModeType(this.value, [this.description]);

  static ForceEntryModeType fromValue(String value) {
    return ForceEntryModeType.values.firstWhere(
          (mode) => mode.value == value,
      orElse: () => throw ArgumentError('Invalid value: $value'),
    );
  }
}

enum CommunicationMode {
  local,
  cloud

}
