import 'dart:convert';

import 'package:apms_mobile/exceptions/exception.dart';
import 'package:apms_mobile/utils/utils.dart';
import 'package:forex_conversion/forex_conversion.dart';

import '../../constants/paths.dart' as paths;
import 'package:http/http.dart' as http;

class TopupRepo {
  Future<int> getExchangeRate() async {
    final fx = Forex();
    Map<String, double> allPrices = await fx.getAllCurrenciesPrices();
    double exchangeRate = allPrices["VND"] ?? 24000.0;
    return exchangeRate.round();
  }

  Future<dynamic> makeTopupTransaction(int amount) async {
    final headers = await Utils().getHeaderValues();
    final makeTopupTransactionUri =
        Uri.http(paths.authority, paths.transactions);
    var body = json.encode({"amount": amount});

    final response =
        await http.post(makeTopupTransactionUri, headers: headers, body: body);
    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }
    return jsonDecode(response.body);
  }
}
