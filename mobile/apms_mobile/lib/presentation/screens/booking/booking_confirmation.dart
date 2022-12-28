import 'package:apms_mobile/bloc/booking_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:apms_mobile/main.dart';
import 'package:apms_mobile/models/car_park_model.dart';
import 'package:apms_mobile/models/ticket_model.dart';
import 'package:apms_mobile/themes/colors.dart';
import 'package:apms_mobile/themes/fonts.dart';
import 'package:apms_mobile/utils/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingConfirmation extends StatefulWidget {
  const BookingConfirmation(
      {Key? key,
      required this.plateNumber,
      required this.arrivalTime,
      required this.carPark})
      : super(key: key);
  final CarParkModel carPark;
  final String plateNumber;
  final DateTime arrivalTime;

  @override
  State<BookingConfirmation> createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final BookingBloc _bookingBloc = BookingBloc();
  late String plateNumber = plateNumber;
  late DateTime arrivalTime = arrivalTime;
  late CarParkModel carPark = carPark;

  @override
  void initState() {
    _bookingBloc.add(SubmitBookingFormStep1(
        widget.plateNumber, widget.arrivalTime, widget.carPark.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: deepBlue),
            title: const Text("Booking Confirmation",
                style: TextStyle(color: deepBlue)),
            backgroundColor: lightBlue),
        body: _buildBookingConfirmationScreen());
  }

  Widget _buildBookingConfirmationScreen() {
    return BlocProvider(
      create: (context) => _bookingBloc,
      child: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) => {
          if (state is BookingPreviewFetchedFailed)
            {errorSnackBar(context, state.message)}
          else if (state is BookingSubmittedSuccessfully)
            {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyHome(
                            tabIndex: 1,
                          ))),
              successfulSnackBar(context, state.message)
            }
          else if (state is BookingSubmittedFailed)
            {Navigator.pop(context), errorSnackBar(this.context, state.message)}
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingPreviewFetching) {
              return _buildLoading();
            } else if (state is BookingPreviewFetchedSuccessfully) {
              return _buildConfirmationCard(context, state.ticketPreview);
            } else {
              return Container();
            }
          },
        ),
      ),
    );

    // return BlocListener<BookingBloc, BookingState>{
    //   (children: [

    // ]);
  }

  Widget _buildConfirmationCard(
      BuildContext context, TicketPreview ticketPreview) {
    return Card(
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticketPreview.carParkName.toUpperCase(),
                style: carParkNameTextStyle,
              ),
              const SizedBox(height: 10),
              Text("Address: ${ticketPreview.carParkAddress}"),
              const SizedBox(height: 10),
              Text("Plate number: ${ticketPreview.plateNumber}"),
              const SizedBox(height: 10),
              Text("Expected arrival time: ${ticketPreview.arriveTime}"),
              const SizedBox(height: 10),
              ticketPreview.priceTable == []
                  ? Text(
                      "Price: ${ticketPreview.feePerHour.toString()} VND/hour")
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          const Text("Price: "),
                          const SizedBox(height: 10),
                          Table(
                            border: TableBorder.all(),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FlexColumnWidth(),
                              1: FlexColumnWidth(),
                              2: FlexColumnWidth()
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: _buildPriceList(ticketPreview.priceTable),
                          )
                        ]),
              const SizedBox(height: 40),
              Text(
                  "Reservation fee: ${ticketPreview.reservationFee.toStringAsFixed(0)} VND (${ticketPreview.reservationFeePercentage}%)"),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,
                child: ElevatedButton(
                    onPressed: () => {
                          _bookingBloc.add(SubmitBookingFormStep2(
                              widget.plateNumber,
                              widget.arrivalTime,
                              widget.carPark.id))
                        },
                    child: const Text("Pay")),
              ),
              const SizedBox(height: 30),
              const Text(
                  "* Booking information once submitted cannot be changed",
                  style: cautionTextStyle),
              const Text(
                  "** A one hour overdue fee will be charged if your arrival is less than 30 minutes late",
                  style: cautionTextStyle),
              const Text(
                  "*** Ticket will be automatically canceled after 30 minutes from your registered arrival time if no check-in request is recorded",
                  style: cautionTextStyle),
              const Text(
                  "**** The parking fee will be calculated separately, starting from your actual arrival time",
                  style: cautionTextStyle),
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildPriceList(List<dynamic> priceTable) {
    List<TableRow> priceList = [];
    priceList.add(TableRow(
        children: _buildPriceTableCells([
      const Text("From", style: carParkNameTextStyle),
      const Text("To", style: carParkNameTextStyle),
      const Text("Price per hour", style: carParkNameTextStyle)
    ])));
    for (var priceRange in priceTable) {
      {
        priceList.add(TableRow(
            children: _buildPriceTableCells([
          Text(priceRange["fromTime"]),
          Text(priceRange["toTime"]),
          Text("${priceRange["fee"].toString()} VND"),
        ])));
      }
    }
    return priceList;
  }

  List<Container> _buildPriceTableCells(List<Text> data) {
    List<Container> tableCells = [];
    for (Text text in data) {
      tableCells.add(Container(
        padding: const EdgeInsets.only(left: 10),
        child: text,
      ));
    }
    return tableCells;
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
