import 'dart:developer';

import 'package:apms_mobile/bloc/topup_bloc.dart';
import 'package:apms_mobile/themes/icons.dart';
import 'package:apms_mobile/utils/appbar.dart';
import 'package:apms_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class TopUp extends StatefulWidget {
  const TopUp({Key? key}) : super(key: key);

  @override
  State<TopUp> createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final TopupBloc _topupBloc = TopupBloc();

  int exchangeRate = 24000;
  int selectedPriceVND = 0;
  List<int> priceList = [10000, 20000, 50000, 100000, 200000, 500000];

  @override
  void initState() {
    _topupBloc.add(FetchExchangeRate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldMessengerKey,
        appBar: AppBarBuilder().appBarDefaultBuilder("Topup"),
        body: _buildTopupScreenBody());
  }

  Widget _buildTopupScreenBody() {
    return BlocProvider(
        create: (_) => _topupBloc,
        child: BlocBuilder<TopupBloc, TopupState>(builder: (context, state) {
          if (state is ExchangeRateFetching ||
              state is TopupTransactionProcessing) {
            return Utils().buildLoading();
          } else if (state is ExchangeRateFetchedSuccessfully) {
            return Column(children: [
              const SizedBox(
                height: 35,
              ),
              _buildPriceSummary(state.exchangeRate),
              _buildTransactionAmountList(),
            ]);
          } else if (state is TopupTransactionProcessedSuccessfully) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                  transactionSuccessfullyIcon,
                  SizedBox(height: 30),
                  Text("Topup successfully!")
                ]));
          } else {
            return Container();
          }
        }));
  }

  Widget _buildPriceSummary(int exchangeRate) {
    return Column(children: [
      Text("Current exchange rate: 1\$ = ${exchangeRate.toString()} VND"),
    ]);
  }

  Widget _buildTransactionAmountList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          priceList.map((price) => _buildTransactionAmountCard(price)).toList(),
    );
  }

  Widget _buildTransactionAmountCard(int price) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
        child: ElevatedButton(
          onPressed: () => createTransaction(
              (price / exchangeRate).toStringAsFixed(2), price),
          child: SizedBox(
              width: 400,
              height: 50,
              child: Row(children: [
                Text(
                    "$price VND (${(price / exchangeRate).toStringAsFixed(2)}\$)"),
                const Spacer(),
                paypalIcon
              ])),
        ));
  }

  dynamic createTransaction(String priceInUSD, int priceInVND) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId:
                "ATieM7Go7V7t-SULEoxgYsiuf7lHDV3XRYKiqYyjfTfvKstL0l211tmjSdUW_h2agCHnUG92Pc-Wusot",
            secretKey:
                "EEvIYjJFwy3GyG6cnreRKjrZTzhPmleTVDNZRzE49P-cmh_CpBFP_TPqHGaQT_n_bk1WpaO6YV_Gz6Tj",
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: [
              {
                "amount": {
                  "total": priceInUSD,
                  "currency": "USD",
                  "details": {
                    "subtotal": priceInUSD,
                  }
                },
                "description": "Topup APMS account",
                "item_list": {
                  "items": [
                    {
                      "name": "Topup package: $priceInVND VND",
                      "quantity": 1,
                      "price": priceInUSD,
                      "currency": "USD"
                    }
                  ],
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              _topupBloc.add(MakeTopupTransaction(priceInVND));
            },
            onError: (error) {
              log("onError: $error");
            },
            onCancel: (params) {
              log('cancelled: $params');
            }),
      ),
    );
  }
}
