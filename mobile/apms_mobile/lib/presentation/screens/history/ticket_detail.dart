import 'dart:async';

import 'package:apms_mobile/bloc/repositories/ticket_repo.dart';
import 'package:apms_mobile/bloc/ticket_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:apms_mobile/main.dart';
import 'package:apms_mobile/models/ticket_model.dart';
import 'package:apms_mobile/presentation/components/alert_dialog.dart';
import 'package:apms_mobile/presentation/components/local_noti.dart';
import 'package:apms_mobile/presentation/screens/qr/qr_scan.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TicketDetail extends StatefulWidget {
  final Ticket ticket;
  const TicketDetail({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketDetail> createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  Duration duration = const Duration(seconds: 0);
  List<String> parts = [];
  String stringDuration = "";
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer _timer = Timer(
    Duration.zero,
    () {},
  );
  @override
  void initState() {
    super.initState();
    LocalNoti.initialize(flutterLocalNotificationsPlugin);
    switch (widget.ticket.status) {
      case 1:
        if (widget.ticket.startTime is DateTime) {
          _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            setState(() {
              duration = DateTime.now().difference(widget.ticket.startTime);
              parts = duration.toString().split(':');
              stringDuration =
                  '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
            });
          });
        }
        break;
      case 2:
        if (widget.ticket.startTime is DateTime &&
            widget.ticket.endTime is DateTime) {
          duration = DateTime.parse(widget.ticket.endTime.toString())
              .difference(widget.ticket.startTime);
          parts = duration.toString().split(':');
          stringDuration =
              '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
        break;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeigth = MediaQuery.of(context).size.height;

    final currencyFormatter = NumberFormat.currency(
      name: '₫',
      decimalDigits: 0,
      customPattern: '#,##0 \u00A4',
    );
    return BlocProvider(
      create: (context) => TicketBloc(TicketRepo()),
      child: BlocListener<TicketBloc, TicketState>(
        listener: (context, state) {
          if (state is TicketCanceled) {
            final snackBar = SnackBar(
              /// need to set following properties for best effect of awesome_snackbar_content
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Canceled Successfully',
                message: 'Your booking has been canceled',

                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                contentType: ContentType.warning,
              ),
            );

            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    const MyHome(tabIndex: 1, headerTabIndex: 3),
              ),
            );
          }
        },
        child: BlocBuilder<TicketBloc, TicketState>(
          builder: (context, state) {
            if (state is TicketCanceling) {
              return _buildLoading();
            } else {
              return Scaffold(
                body: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Fee header
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: FittedBox(
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Color(0xff3192e1),
                                  )),
                            ),
                          ),
                          FittedBox(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(screenWidth * 0.1,
                                  screenHeigth * 0.1, screenWidth * 0.1, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: screenHeigth * 0.16,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                decoration: BoxDecoration(
                                  color: const Color(0xffe3f2fd),
                                  borderRadius: BorderRadius.circular(21),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x19000000),
                                      offset: Offset(2, 4),
                                      blurRadius: 3.5,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 4),
                                            child: Text(
                                              'Total fee:',
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                color: const Color(0xff3192e1),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            currencyFormatter.format(widget
                                                    .ticket.totalFee +
                                                widget.ticket.reservationFee),
                                            style: GoogleFonts.inter(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xff3192e1),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    (widget.ticket.status != 2 &&
                                            widget.ticket.status != -1)
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const QRScan(),
                                              ));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 0, 20),
                                              width: 60,
                                              height: 60,
                                              child: const FittedBox(
                                                child: Icon(
                                                  Icons.qr_code_scanner_rounded,
                                                  color: Color(0xff3192e1),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Builder(builder: (context) {
                        return Expanded(
                            child: _buildBody(context, screenWidth));
                      }),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Return the suffix of ordinal number (st, nd ,th)
  String ordinal(int number) {
    if (number >= 11 && number <= 13) {
      return 'th';
    }

    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  // Loading circle
  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  SingleChildScrollView _buildBody(BuildContext context, double screenWidth) {
    var dateFormater = DateFormat("MMM yyyy");
    var timeFormater = DateFormat("HH:mm:ss");
    final currencyFormatter = NumberFormat.currency(
      name: '₫',
      decimalDigits: 0,
      customPattern: '#,##0 \u00A4',
    );
    final bloc = context.read<TicketBloc>();
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _halfLeft(screenWidth, dateFormater, timeFormater),
              _halfRight(
                  screenWidth, timeFormater, dateFormater, currencyFormatter),
            ],
          ),
          Divider(
            thickness: 2,
            indent: screenWidth * 0.12,
            endIndent: screenWidth * 0.12,
            height: 20,
            color: Colors.blue,
          ),
          (widget.ticket.status != -1 && widget.ticket.status != 0)
              ? _bodyTotal(screenWidth, currencyFormatter)
              : const SizedBox(),
          (widget.ticket.status != -1 && widget.ticket.status != 0)
              ? Divider(
                  thickness: 2,
                  indent: screenWidth * 0.12,
                  endIndent: screenWidth * 0.12,
                  height: 20,
                  color: Colors.blue,
                )
              : const SizedBox(),
          _buildImage(screenWidth, context),
          const SizedBox(
            height: 10,
          ),
          widget.ticket.status == 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      final action = await AlertDialogs.confirmCancelDiaglog(
                          context,
                          "Cancel Booking",
                          "Are you sure? Your booking ticket will be terminated, and this action cannot be reverted");
                      if (action == DialogsAction.confirm) {
                        bloc.add(CancelBooking(widget.ticket.id));
                      }
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.cancel,
                          size: 24.0,
                        ),
                        Text('Cancel Booking'),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          widget.ticket.status == 2
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      side: MaterialStatePropertyAll(
                        BorderSide(
                          width: 2,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: screenWidth * 0.4,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.greenAccent,
                            size: 24.0,
                          ),
                          Text(' Done',
                              style: TextStyle(color: Colors.greenAccent)),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          widget.ticket.status == -1
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      side: MaterialStatePropertyAll(
                        BorderSide(
                          width: 2,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: screenWidth * 0.4,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.cancel,
                            color: Colors.black54,
                            size: 24.0,
                          ),
                          Text(' Cancelled',
                              style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Row _buildImage(double screenWidth, BuildContext context) {
    return Row(
      children: [
        (RegExp(r'^https:\/\/storage\.googleapis\.com\/apms-48bd5\.appspot\.com')
                    .hasMatch(widget.ticket.picInUrl) &&
                widget.ticket.status != 0)
            ? Column(
                children: [
                  FittedBox(
                    child: Container(
                      width: screenWidth * 0.4,
                      margin: EdgeInsets.fromLTRB(screenWidth * 0.08, 20, 0, 0),
                      child: SizedBox(
                        height: 25,
                        child: Text(
                          'Check-in picture',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff828282),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(screenWidth * 0.08, 10, 0, 0),
                    child: SizedBox(
                      width: screenWidth * 0.4,
                      child: InkWell(
                          child: Image.network(
                            widget.ticket.picInUrl,
                            fit: BoxFit.scaleDown,
                          ),
                          onTap: () {
                            showImageViewer(
                                context, NetworkImage(widget.ticket.picInUrl));
                          }),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
        (RegExp(r'^https:\/\/storage\.googleapis\.com\/apms-48bd5\.appspot\.com')
                    .hasMatch(widget.ticket.picOutUrl) &&
                widget.ticket.status != 0)
            ? Column(
                children: [
                  FittedBox(
                    child: Container(
                      width: screenWidth * 0.4,
                      margin: EdgeInsets.fromLTRB(screenWidth * 0.06, 20, 0, 0),
                      child: SizedBox(
                        height: 25,
                        child: Text(
                          'Check-out picture',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff828282),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(screenWidth * 0.04, 10, 0, 0),
                    child: SizedBox(
                      width: screenWidth * 0.4,
                      child: InkWell(
                          child: Image.network(
                            widget.ticket.picOutUrl,
                            fit: BoxFit.scaleDown,
                          ),
                          onTap: () {
                            showImageViewer(
                                context, NetworkImage(widget.ticket.picOutUrl));
                          }),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  Row _bodyTotal(double screenWidth, NumberFormat currencyFormatter) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            FittedBox(
              child: Container(
                width: screenWidth * 0.4,
                margin: EdgeInsets.fromLTRB(screenWidth * 0.1, 20, 0, 0),
                child: SizedBox(
                  height: 25,
                  child: Text(
                    'Duration',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff828282),
                    ),
                  ),
                ),
              ),
            ),
            FittedBox(
              child: Container(
                width: screenWidth * 0.4,
                margin: EdgeInsets.fromLTRB(screenWidth * 0.1, 20, 0, 0),
                child: SizedBox(
                  height: 25,
                  child: Text(
                    'Parking Fee',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff828282),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Container(
                margin: EdgeInsets.fromLTRB(screenWidth * 0.06, 20, 0, 0),
                child: SizedBox(
                  height: 25,
                  child: Text(
                    stringDuration,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            FittedBox(
              child: Container(
                margin: EdgeInsets.fromLTRB(screenWidth * 0.06, 20, 0, 0),
                child: SizedBox(
                  height: 25,
                  child: Text(
                    currencyFormatter.format(widget.ticket.totalFee),
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _halfRight(double screenWidth, DateFormat timeFormater,
      DateFormat dateFormater, NumberFormat currencyFormatter) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Container(
            margin: EdgeInsets.fromLTRB(screenWidth * 0.08, 40, 0, 0),
            child: SizedBox(
              height: 25,
              child: Text(
                'Plate Number',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff828282),
                ),
              ),
            ),
          ),
        ),
        FittedBox(
          child: Container(
            margin: EdgeInsets.fromLTRB(screenWidth * 0.08, 6, 0, 0),
            child: SizedBox(
              height: 25,
              child: Text(
                widget.ticket.plateNumber,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        widget.ticket.reservationFee > 0
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.08, 26, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      currencyFormatter.format(widget.ticket.reservationFee),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        widget.ticket.arriveTime is DateTime
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.08, 26, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      'Arrive Time',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff828282),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        // Arrive Time
        widget.ticket.arriveTime is DateTime
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.08, 6, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      timeFormater.format(widget.ticket.arriveTime),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        // Arrive Date
        widget.ticket.arriveTime is DateTime
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.08, 0, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      "${widget.ticket.arriveTime.day}${ordinal(widget.ticket.arriveTime.day).toString()} ${dateFormater.format(widget.ticket.arriveTime!)}",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        widget.ticket.endTime is DateTime
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.08, 26, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      'Check-out Time',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff828282),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        // Arrive Time
        widget.ticket.endTime is DateTime
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.08, 6, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      timeFormater.format(widget.ticket.endTime),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        // Arrive Date
        widget.ticket.endTime is DateTime
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.08, 0, 0, 20),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      "${widget.ticket.endTime.day}${ordinal(widget.ticket.endTime.day).toString()} ${dateFormater.format(widget.ticket.endTime!)}",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Column _halfLeft(
      double screenWidth, DateFormat dateFormater, DateFormat timeFormater) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Container(
            margin: EdgeInsets.fromLTRB(screenWidth * 0.1, 40, 0, 0),
            child: SizedBox(
              height: 25,
              child: Text(
                'Name',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff828282),
                ),
              ),
            ),
          ),
        ),
        // Name
        FittedBox(
          child: Container(
            margin: EdgeInsets.fromLTRB(screenWidth * 0.1, 6, 0, 0),
            child: SizedBox(
              height: 25,
              child: Text(
                widget.ticket.fullName,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        widget.ticket.reservationFee > 0
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.1, 26, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      'Reservation fee',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff828282),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        widget.ticket.bookTime is DateTime
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.1, 26, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      'Book Time',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff828282),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        // Book Time
        widget.ticket.bookTime is DateTime
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.1, 6, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      timeFormater.format(widget.ticket.bookTime!),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        widget.ticket.bookTime is DateTime
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.1, 0, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      "${widget.ticket.bookTime.day}${ordinal(widget.ticket.bookTime.day).toString()} ${dateFormater.format(widget.ticket.bookTime!)}",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        widget.ticket.startTime is DateTime
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.1, 26, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      'Check-in Time',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff828282),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        // Check-in Time
        widget.ticket.startTime is DateTime
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.1, 6, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      timeFormater.format(widget.ticket.startTime),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        // Check-in Date
        widget.ticket.startTime is DateTime
            ? FittedBox(
                child: Container(
                  margin: EdgeInsets.fromLTRB(screenWidth * 0.1, 0, 0, 0),
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      widget.ticket.startTime is DateTime
                          ? "${widget.ticket.startTime.day}${ordinal(widget.ticket.startTime.day).toString()} ${dateFormater.format(widget.ticket.startTime!)}"
                          : "No data",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}


// address format : "${widget.ticket.carPark.name} - ${widget.ticket.carPark.addressNumber}, ${widget.ticket.carPark.street}, ${widget.ticket.carPark.ward}, ${widget.ticket.carPark.district}, ${widget.ticket.carPark.city}"