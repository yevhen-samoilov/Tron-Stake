String abbreviateNumber(num n) {
  if (n < 1000) return n.toString();

  final units = ['K', 'M', 'B', 'T'];
  int unitIndex = 0;

  while (n >= 1000) {
    unitIndex++;
    n = n ~/ 1000;
  }

  return n.toString() + units[unitIndex - 1];
}
