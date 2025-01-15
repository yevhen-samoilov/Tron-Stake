int validatorLength(String? value) {
  if (value == null || value.isEmpty) {
    return 0;
  }
  if (value.length < 6) {
    return 1;
  }
  return -1;
}

String? validatorLengthText(localizations, String type, String? value) {
  if (0 == validatorLength(value)) {
    return '${localizations.s35} $type';
  }
  if (1 == validatorLength(value)) {
    return localizations.s37;
  }
  return null;
}
