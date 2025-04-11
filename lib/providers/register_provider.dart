import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirmPassword = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm2() {
    print(formKey.currentState?.validate());
    print('$email - $password - $confirmPassword');
    return formKey.currentState?.validate() ?? false;
  }
}
