import 'package:apms_mobile/bloc/booking_bloc.dart';
import 'package:apms_mobile/exceptions/exception.dart';
import 'package:apms_mobile/models/car_park_model.dart';
import 'package:apms_mobile/presentation/screens/booking/booking_confirmation.dart';
import 'package:apms_mobile/themes/colors.dart';
import 'package:apms_mobile/utils/popup.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class Booking extends StatefulWidget {
  const Booking({Key? key, required this.carPark}) : super(key: key);
  final CarParkModel carPark;

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String plateNumber = "";
  late CarParkModel carPark = widget.carPark;
  final BookingBloc _bookingBloc = BookingBloc();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController arrivalTimeController = TextEditingController();
  final TextEditingController arrivalDateController = TextEditingController();
  late DateTime arrivalDateTime;

  @override
  void initState() {
    _bookingBloc.add(BookingFieldInitial());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: deepBlue),
          title: const Text("Booking", style: TextStyle(color: deepBlue)),
          backgroundColor: lightBlue),
      body: _buildBookingScreen(),
    );
  }

  Widget _buildBookingScreen() {
    return BlocProvider(
        create: (_) => _bookingBloc,
        child: BlocListener<BookingBloc, BookingState>(listener:
            (context, state) {
          if (state is BookingSubmittedFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        }, child:
            BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [_carParkSmallDetailCard(), _carParkBookingForm()]);
        })));
  }

  Widget _carParkSmallDetailCard() {
    return Card(
        child: ListTile(
            title: Text(carPark.name),
            subtitle: Text(
                "${carPark.addressNumber} ${carPark.street}, ${carPark.district}, ${carPark.city}")));
  }

  Widget _carParkBookingForm() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SizedBox(
          width: 600,
          child: Column(children: [
            _plateNumberField(),
            const SizedBox(height: 10),
            _datePickerField(),
            const SizedBox(height: 10),
            _timePickerField(),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  try {
                    validateBookingForm();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingConfirmation(
                                carPark: widget.carPark,
                                plateNumber: plateNumberController.text,
                                arrivalTime: arrivalDateTime)));
                  } catch (e) {
                    errorSnackBarWithDismiss(context, e.toString());
                  }
                },
                child: const Text("Go to confirmation page"))
          ]),
        ));
  }

  Widget _plateNumberField() {
    return BlocProvider(
        create: (_) => _bookingBloc,
        child:
            BlocBuilder<BookingBloc, BookingState>(builder: (context, state) {
          if (state is UsedPlateNumbersFetchedSuccessfully) {
            return SingleChildScrollView(
                child: SizedBox(
              width: 400,
              child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: plateNumberController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z0-9-]'))
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          labelText: "Plate number (eg. 60A-12345)")),
                  suggestionsCallback: (pattern) {
                    List<String> matches = <String>[];
                    matches.addAll(state.plateNumbersList);

                    matches.retainWhere((s) {
                      return s.toLowerCase().contains(pattern.toLowerCase());
                    });
                    return matches;
                  },
                  itemBuilder: (context, sone) {
                    return Card(
                        child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Text(sone.toString().toUpperCase()),
                    ));
                  },
                  onSuggestionSelected: (suggestion) {
                    plateNumberController.text =
                        suggestion.toString().toUpperCase();
                  }),
            ));
          } else {
            return TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9-]'))
              ],
              controller: plateNumberController,
              decoration: InputDecoration(
                enabled: true,
                labelText: "Plate number (eg. 60A-12345)",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            );
          }
        }));
  }

  Widget _datePickerField() {
    const String dateFormat = "dd-MM-yyyy";
    return DateTimeField(
        controller: arrivalDateController,
        decoration: InputDecoration(
          enabled: true,
          labelText: "Arrival date",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
        format: DateFormat(dateFormat),
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime.now().add(const Duration(hours: 24)));
          return date;
        });
  }

  Widget _timePickerField() {
    const String timeFormat = "HH:mm";
    return DateTimeField(
        controller: arrivalTimeController,
        decoration: InputDecoration(
          enabled: true,
          labelText: "Arrival time",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
        format: DateFormat(timeFormat),
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.convert(time);
        });
  }

  void validateBookingForm() {
    const dateTimeFormat = "dd-MM-yyyy HH:mm";

    if (plateNumberController.text == "") {
      throw HttpException("Please enter your vehicle plate number!");
    }

    if (arrivalDateController.text == "") {
      throw HttpException("Please pick an arrival date");
    }

    if (arrivalTimeController.text == "") {
      throw HttpException("Please pick an arrival time");
    }

    DateTime selectedDateTime = DateFormat(dateTimeFormat)
        .parse("${arrivalDateController.text} ${arrivalTimeController.text}");
    if (selectedDateTime.compareTo(DateTime.now()) < 0 ||
        selectedDateTime
                .compareTo(DateTime.now().add(const Duration(hours: 24))) >
            0) {
      throw HttpException("Date time must be within 24 hours!");
    }

    setState(() {
      arrivalDateTime = selectedDateTime;
    });
  }
}
