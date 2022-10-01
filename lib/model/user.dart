import 'package:shifty/controller/debugger.dart';

import '../controller/api.dart';

class User {
  late final String name;
  final String email;
  final String id;
  final String _password;
  late String _bearer;

  late final String phone;
  late final int group;

  static Future<User> create(String email, String id, String password) async {
    final user = User._create(email, id, password);
    await user._init();

    return user;
  }

  User._create(this.email, this.id, this._password);

  Future<void> _refreshBearer() async {
    _bearer = 'Bearer ${await API.auth(email, _password)}';
  }

  Future<void> _init() async {
    await _refreshBearer();
    final data = await API.getEmployeeData(_bearer, id);

    name = data['name'];
    phone = data['phone_number'];
    group = data['batch_number'];
  }
}
