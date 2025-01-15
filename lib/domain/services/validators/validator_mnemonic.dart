String? mnemonicValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a mnemonic phrase.';
  }

  // Split the mnemonic into words
  List<String> words = value.trim().split(RegExp(r'\s+'));

  // Check for the correct number of words
  if (![12, 18, 24].contains(words.length)) {
    return 'Mnemonic must have 12, 18, or 24 words.';
  }

  // Check for invalid characters
  if (words.any((word) => !RegExp(r'^[a-zA-Z]+$').hasMatch(word))) {
    return 'Mnemonic must contain only letters.';
  }

  // All checks passed
  return null;
}
