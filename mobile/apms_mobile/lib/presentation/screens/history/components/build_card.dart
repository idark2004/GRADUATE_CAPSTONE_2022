import 'dart:async';

import 'package:apms_mobile/bloc/repositories/ticket_repo.dart';
import 'package:apms_mobile/bloc/ticket_bloc.dart';
import 'package:apms_mobile/models/ticket_model.dart';
import 'package:apms_mobile/presentation/screens/history/components/card_duration.dart';
import 'package:apms_mobile/presentation/screens/history/ticket_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

class BuildCard extends StatefulWidget {
  final String type;
  const BuildCard({Key? key, required this.type}) : super(key: key);

  @override
  State<BuildCard> createState() => _BuildCardState();
}

class _BuildCardState extends State<BuildCard> {
  List items = [];
  List prevItems = [];
  int currentPage = 1;
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
    double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => TicketBloc(TicketRepo()),
      child: BlocBuilder<TicketBloc, TicketState>(
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
                context.read<TicketBloc>().add(GetTicketList(
                    dateChanged ? DateFormat('yyyy-MM-dd').format(start) : "",
                    dateChanged ? DateFormat('yyyy-MM-dd').format(end) : "",
                    '',
                    widget.type,
                    currentPage,
                    loadMore));
              }
            }
          });
          if (state is TicketInitial) {
            context.read<TicketBloc>().add(GetTicketList(
                dateChanged ? DateFormat('yyyy-MM-dd').format(start) : "",
                dateChanged ? DateFormat('yyyy-MM-dd').format(end) : "",
                '',
                widget.type,
                currentPage,
                loadMore));
            return _buildLoading();
          } else if (state is TicketLoading) {
            return _buildLoading();
          } else if (state is TicketLoaded) {
            loadMore = false;
            maxPage = state.ticket.totalPage;
            if (items.isEmpty) {
              items = state.ticket.tickets;
              prevItems = items;
            } else if (!listEquals(state.ticket.tickets, prevItems)) {
              prevItems = state.ticket.tickets;
              List newList = items + state.ticket.tickets;
              items = newList;
              loadMore = false;
            }

            return Builder(builder: (context) {
              return _buildCard(context, items, width);
            });
          } else {
            return Container();
          }
        },
      ),
    );
  }

  // Loading circle
  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  // Build list
  Widget _buildCard(BuildContext context, List items, double width) {
    return Column(
      children: [
        if (widget.type == "Done")
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: width * 0.6,
                child: TextButton(
                  onPressed: () async {
                    await pickDateRange(context);
                  },
                  child: Text(
                      "${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}"),
                ),
              )
            ],
          ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length + 1,
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index == items.length &&
                  items.isNotEmpty &&
                  currentPage < maxPage) {
                return _buildLoading();
              } else if (index < items.length) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            TicketDetail(ticket: items[index]),
                      ),
                    );
                  },
                  child: GFCard(
                    boxFit: BoxFit.cover,
                    title: GFListTile(
                      title: Text(
                        items[index].plateNumber.toString().toUpperCase(),
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      subTitle: Text(items[index].carPark.name),
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _cardBody(items[index]),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  Future pickDateRange(BuildContext context) async {
    TicketBloc bloc = context.read<TicketBloc>();
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
      dateChanged = true;
    });
    bloc.add(ChangeTicketDate());
  }

  // Card Body
  List<Widget> _cardBody(Ticket ticket) {
    double screenWidth = MediaQuery.of(context).size.width;
    var dateFormater = DateFormat("dd-MM-yyyy HH:mm");

    String checkinTime = ticket.startTime is DateTime
        ? dateFormater.format(ticket.startTime!)
        : "";
    final currencyFormatter = NumberFormat.currency(
      name: '₫',
      decimalDigits: 0,
      customPattern: '#,##0 \u00A4',
    );
    if (ticket.status == 0 || ticket.status == -1) {
      String bookTime = ticket.bookTime is DateTime
          ? dateFormater.format(ticket.bookTime!)
          : "";
      String arriveTime = ticket.arriveTime is DateTime
          ? dateFormater.format(ticket.arriveTime!)
          : "";
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.04),
                  child: const Text("Book Time")),
            ),
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.04),
                  child: const Text("Reservation fee")),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 0,
              child: Padding(
                  padding: EdgeInsets.only(top: 4, left: screenWidth * 0.04),
                  child: Text(
                    bookTime,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(top: 4, right: screenWidth * 0.04),
                child: Text(
                  currencyFormatter.format(ticket.reservationFee),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(top: 2, left: screenWidth * 0.04),
                  child: const Text("Arrive Time")),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(top: 4, left: screenWidth * 0.04),
                  child: Text(
                    arriveTime,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ];
    } else if (ticket.status == 1) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.06),
                  child: const Text("Check-in date")),
            ),
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.08),
                  child: const Text("Check-in time")),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.06),
                child: Text(
                  checkinTime.split(" ")[0],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.08),
                  child: Text(
                    checkinTime.split(" ")[1],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
        const Divider(
          color: Colors.blue,
          //height: 25,
          thickness: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.08),
                  child: CardDuration(checkInTime: ticket.startTime)),
            ),
          ],
        ),
      ];
    } else {
      String checkoutTime = ticket.endTime is DateTime
          ? dateFormater.format(ticket.endTime!)
          : "";

      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.04),
                  child: const Text("Check-in Time")),
            ),
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.04),
                  child: const Text("Total fee")),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 0,
              child: Padding(
                  padding: EdgeInsets.only(top: 4, left: screenWidth * 0.04),
                  child: Text(
                    checkinTime,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(top: 4, right: screenWidth * 0.04),
                child: Text(
                  currencyFormatter
                      .format(ticket.totalFee + ticket.reservationFee),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(top: 2, left: screenWidth * 0.04),
                  child: const Text("Check-out Time")),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(top: 4, left: screenWidth * 0.04),
                  child: Text(
                    checkoutTime,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ];
    }
  }
}
