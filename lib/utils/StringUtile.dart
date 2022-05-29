class StringUtile {
  static bool isEmpty(String string) {
    if (string == null) {
      return true;
    }
    if (string == '') {
      return true;
    }
    return false;
  }
}
