import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    email: '',
    username: '',
    uid: '',
  );

  UserModel get user => _user;

  setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
