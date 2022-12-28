import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String greeting;
  const Header({Key? key, required this.greeting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          './assets/images/logo.png',
          scale: 2,
        ),
        const SizedBox(
          height: 18,
        ),
        Text(
          greeting,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontFamily: 'Times',
          ),
        ),
      ],
    );
  }
}
