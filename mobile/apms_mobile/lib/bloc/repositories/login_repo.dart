import 'dart:convert';

import 'package:apms_mobile/models/login_model.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/apis.dart' as apis;


class LoginRepo {

  Future<bool> login(LoginModel loginModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final loginApi = Uri.parse(apis.login);
    try {
      // Authenticate
      Response res = await post(loginApi,
          headers: apis.headers, body: jsonEncode(loginModel));
      if (res.statusCode == 200) {
        Map body = json.decode(res.body);
        String token = body['data'];
        await pref.setString('token', token);
        return true;
      }
    } catch (error) {
      return false;
    }
    return false;
  }
}
