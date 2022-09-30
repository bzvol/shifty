import '../controller/rooster_api.dart';

class User {
  late final String name;
  final String email;
  final String id;
  final String _password;
  late String _bearerToken;

  /*factory User.createWithAuth(String email, String id, String password) async {
    final user = User(email, id, password);
    user._bearerToken = 'Bearer ' + ;
    return user;
  }*/

  static Future<User> createWithAuth(String email, String id, String password) async {
    final user = User(email, id, password);
    user._bearerToken = 'Bearer ${await RoosterAPI.auth(email, password)}';
    return user;
  }

  User(this.email, this.id, String password) : _password = password;
}