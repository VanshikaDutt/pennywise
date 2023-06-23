extension Casing on String {
  String get titleCase {
    if (isEmpty) {
      return this;
    }

    final words = split(' ');
    final capitalizedWords = words.map((word) {
      final firstLetter = word.substring(0, 1).toUpperCase();
      final remainingLetters = word.substring(1).toLowerCase();
      return '$firstLetter$remainingLetters';
    });

    return capitalizedWords.join(' ');
  }
}
