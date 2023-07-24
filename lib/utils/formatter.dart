String trimmer(String text) {
  if (text.length <= 32) {
    return text;
  } else {
    return '${text.substring(0, 32)}...';
  }
}
