import 'package:http/http.dart';

import '../../constants/apis.dart' as apis;
import 'dart:convert';

class SignUpRepo {
  Future<String> signUp(
      String phoneNumber, String fullname, String password) async {
    final Uri signUpApi = Uri.parse(apis.signup);

    // request body
    Map<String, String> body = {
      "phoneNumber": phoneNumber,
      "fullName": fullname,
      "password": password
    };
    final requestBody = json.encode(body);

    Response res = await post(
      signUpApi,
      headers: apis.headers,
      body: requestBody,
    );
    if (res.statusCode == 201) {
      return "Sign-up Successfully";
    } else {
      String message = res.body;
      return message;
    }
  }
}
