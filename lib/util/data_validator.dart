class DataValidator {
  String? passwordValidator(String? password) {
    if ((password == null) || (password.isEmpty)) {
      return "Please enter a Password";
    }

    if (password.length < 4) {
      return "Password must be at least 4 characters long";
    }

    if (password.contains(" ")) {
      return "Password cannot have spaces.";
    }

    return null;
  }

  String? nullEmailValidator(String? value) {
    if (value == null) {
      return null;
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$');
    if (value.isEmpty) {
      return null;
    }
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid Email';
    }
    return null;
  }

  String? nullPhoneNumberValidator(String? value) {
    if (value == null) {
      return null;
    }
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (value.isEmpty) {
      return null;
    }
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid Phone Number. Phone Number can only have digits.';
    }
    if (value.length != 10) {
      return 'Phone Number must be 10 digits long';
    }
    return null;
  }

  String? emailValidator(String? value) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$');
    if (value!.isEmpty) {
      return 'Please enter Email';
    }
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid Email';
    }
    return null;
  }

  String? nameValidator(String? value) {
    final nameRegex = RegExp(r'^[a-zA-Z ]+$');
    if (value!.isEmpty) {
      return 'Please enter Name';
    }
    if (!nameRegex.hasMatch(value)) {
      return 'Please enter a valid Name. Name can only have alphabets and spaces.';
    }
    return null;
  }

  String? phoneNumberValidator(String? value) {
    final phoneRegex = RegExp(r'^[0-9]+$');
    if (value!.isEmpty) {
      return 'Please enter Phone Number';
    }
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid Phone Number. Phone Number can only have digits.';
    }
    if (value.length != 10) {
      return 'Phone Number must be 10 digits long';
    }
    return null;
  }

  String? aadharNumberValidator(String? value) {
    final aadharRegex = RegExp(r'^[0-9]+$');
    if (value!.isEmpty) {
      return 'Please enter Aadhar Number';
    }
    if (!aadharRegex.hasMatch(value)) {
      return 'Please enter a valid Aadhar Number. Aadhar Number can only have digits.';
    }
    if (value.length != 12) {
      return 'Aadhar Number must be 12 digits long';
    }
    return null;
  }

  String? dobValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Date of Birth';
    }
    return null;
  }

  String? genderValidator(String? value) {
    if (value == null) {
      return "Please select your gender";
    }

    if (value != "M" && value != "F") {
      return "Please select your gender";
    }

    return null;
  }

  String? roleValidator(String? value) {
    if (value == null) {
      return "Please select valid role";
    }

    if (value != "A" && value != "H" &&  value != "D" &&  value != "F") {
      return "Please select valid role";
    }

    return null;
  }

  String? addressValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Address';
    }
    return null;
  }
}