import 'package:apms_mobile/bloc/repositories/transaction_repo.dart';
import 'package:apms_mobile/bloc/transaction_bloc.dart';
import 'package:apms_mobile/models/transaction_model.dart';
import 'package:apms_mobile/utils/appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<Transaction> items = [];
  List prevItems = [];
  int currentPage = 1;
  String type = 'All';
  int maxPage = 1;
  ScrollController scrollController = ScrollController();
  bool loadMore = false;
  bool dateChanged = false;
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  @override
  void initState() {
    start = dateRange.start;
    end = dateRange.end;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBarBuilder().appBarDefaultBuilder("Transaction History"),
        body: BlocProvider(
          create: (context) => TransactionBloc(TransactionRepo()),
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              scrollController.addListener(() {
                if (scrollController.position.pixels ==
                        scrollController.position.maxScrollExtent &&
                    loadMore == false) {
                  if (currentPage < maxPage) {
                    setState(() {
                      if (mounted) {
                        currentPage++;
                        loadMore = true;
                      }
                    });
                    context.read<TransactionBloc>().add(
                          GetTransactionHistory(
                              dateChanged
                                  ? DateFormat('yyyy-MM-dd').format(start)
                                  : "",
                              dateChanged
                                  ? DateFormat('yyyy-MM-dd').format(end)
                                  : "",
                              type,
                              currentPage,
                              loadMore),
                        );
                  }
                }
              });
              if (state is TransactionInitial) {
                items = [];
                context.read<TransactionBloc>().add(
                      GetTransactionHistory(
                          dateChanged
                              ? DateFormat('yyyy-MM-dd').format(start)
                              : "",
                          dateChanged
                              ? DateFormat('yyyy-MM-dd').format(end)
                              : "",
                          type,
                          currentPage,
                          loadMore),
                    );
                return _buildLoading();
              } else if (state is GettingTransactionList) {
                return _buildLoading();
              } else if (state is GotTransactionList) {
                loadMore = false;
                maxPage = state.model.totalPage;
                if (items.isEmpty) {
                  items = state.model.transactions;
                  prevItems = items;
                } else if (!listEquals(state.model.transactions, prevItems)) {
                  prevItems = state.model.transactions;
                  List<Transaction> newList = items + state.model.transactions;
                  items = newList;
                  loadMore = false;
                }
                return Builder(
                  builder: (context) {
                    return _buildCard(screenWidth, context, items);
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ));
  }

  Column _buildCard(
      double screenWidth, BuildContext context, List<Transaction> items) {
    List<String> spinnerItems = [
      'All',
      'Top-up',
      'Booking',
      'Parking Fee',
    ];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.08),
              child: Container(),
            ),
            DropdownButton<String>(
              value: type,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 16,
              onChanged: (value) {
                setState(() {
                  items = [];
                  currentPage = 1;
                  type = value!;
                  loadMore = false;
                });
                context.read<TransactionBloc>().add(ChangeTransactionType());
              },
              items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.1),
              child: SizedBox(
                child: TextButton(
                  onPressed: () async {
                    await pickDateRange(context);
                  },
                  child: Text(
                      "${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}"),
                ),
              ),
            ),
          ],
        ),
        items.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length + 1,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    if (index == items.length &&
                        items.isNotEmpty &&
                        currentPage < maxPage) {
                      return _buildLoading();
                    } else if (index < items.length) {
                      return GFCard(
                        boxFit: BoxFit.cover,
                        content: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _cardBody(items[index]),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              )
            : Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                child: const Text(
                  "No transaction found",
                  style: TextStyle(fontSize: 20, fontFamily: "times"),
                )),
      ],
    );
  }

  // Loading circle
  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  Future pickDateRange(BuildContext context) async {
    TransactionBloc bloc = context.read<TransactionBloc>();
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (newDateRange == null) return;

    setState(() {
      dateRange = newDateRange;
      start = dateRange.start;
      end = dateRange.end;
      items = [];
      currentPage = 1;
      loadMore = false;
      dateChanged = true;
    });
    bloc.add(ChangeHistoryDate());
  }

  List<Widget> _cardBody(Transaction transaction) {
    final currencyFormatter = NumberFormat.currency(
      name: '₫',
      decimalDigits: 0,
      customPattern: '#,##0 \u00A4',
    );
    var dateFormater = DateFormat("dd-MM-yyyy HH:mm");

    return [
      Column(
        children: [
          transaction.transactionType == 0 ? const Text("Top-up") : Container(),
          transaction.transactionType == 1
              ? const Text("Booking")
              : Container(),
          transaction.transactionType == 2
              ? const Text("Parking Fee")
              : Container(),
          const SizedBox(
            height: 4,
          ),
          Text(dateFormater.format(transaction.time)),
        ],
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              transaction.transactionType != 0
                  ? "-${currencyFormatter.format(transaction.amount)}"
                  : "+${currencyFormatter.format(transaction.amount)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ];
  }
}
