class Namevalidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be Empty";
    } else {
      return null;
    }
  }
}

class Emailvalidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be Empty";
    } else if (!(RegExp("[a-zA-Z0-9._-]+@[a-z]+.[a-z]+").hasMatch(value))) {
      return "Enter a valid Email Address";
    } else {
      return null;
    }
  }
}

class Passwordvalidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be Empty";
    } else if (value.length < 6) {
      return "Password lenth is too Short(min 6 chars)";
    } else if (value.length > 10) {
      return "Password lenth is too Long(max 10 chars)";
    } else {
      return null;
    }
  }
}

class phoneValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Phone Number can't be Empty";
    } else if (value.length < 10) {
      return "Phone Number lenth is too Short(min 10 chars)";
    } else if (value.length > 10) {
      return "Phone Number lenth is too Long(max 10 chars)";
    } else {
      return null;
    }
  }
}
