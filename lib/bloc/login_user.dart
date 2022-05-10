class LoginUser {
  String _id = "";

  LoginUser({String id = ""}) {
    _id = id;
  }

  String get id {
    if (_id == "") {
      throw Exception("ログインしていません！");
    } else {
      return _id;
    }
  }

  set id(String id) {
    _id = id;
  }
}
