class NumberParser {
  static String removeDecimals(String value) {
    String number = value;
    if (number.contains('.0')) {
      number = number.replaceAll('.0', '');
    }
    return number;
  }

  static int getNumber(String number) {
    return int.parse(removeDecimals(number));
  }
}
