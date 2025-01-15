String shortenString(String input) {
  if (input.length <= 5) {
    return input;
  }
  return '${input.substring(0, 2)}...${input.substring(input.length - 3)}';
}
