class Validation{
  static isPhoneValid(String phone){
    final regexPhone = RegExp(r'^[0-9]+$');
    return regexPhone.hasMatch(phone);
  }

  static isPassValid(String password){
    return password.length>=6;
  }

  static isDisplayName(String name){
    return name.length>=5;
  }
}