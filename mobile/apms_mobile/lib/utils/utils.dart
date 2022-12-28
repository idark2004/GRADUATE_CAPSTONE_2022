import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  Future<Map<String, String>> getHeaderValues() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token')!;
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };
  }

  Widget buildLoading() => const Center(child: CircularProgressIndicator());

  String convertPriceValueToThousandPattern(dynamic value) {
    NumberFormat numberFormat = NumberFormat("#.###");
    return numberFormat.format(value);
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
