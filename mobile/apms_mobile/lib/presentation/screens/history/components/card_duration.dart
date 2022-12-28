import 'dart:async';

import 'package:flutter/material.dart';

class CardDuration extends StatefulWidget {
  final DateTime checkInTime;
  const CardDuration({Key? key, required this.checkInTime}) : super(key: key);

  @override
  State<CardDuration> createState() => _CardDurationState();
}

class _CardDurationState extends State<CardDuration> {
  String stringDuration = "";
  Timer _timer = Timer(
    Duration.zero,
    () {},
  );
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        Duration duration = DateTime.now().difference(widget.checkInTime);
        List parts = duration.toString().split(':');
        stringDuration =
            '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Duration: '),
        Text(
          stringDuration,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
