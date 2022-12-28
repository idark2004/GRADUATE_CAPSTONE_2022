import 'dart:developer';

import 'package:apms_mobile/bloc/repositories/forgot_password_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/forgot_password_bloc.dart';
import '../otp_screen.dart';

class CheckPhone extends StatefulWidget {
  const CheckPhone({Key? key}) : super(key: key);

  @override
  State<CheckPhone> createState() => _CheckPhoneState();
}

class _CheckPhoneState extends State<CheckPhone> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot password"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              child: const Text(
                'Please provide the phone number that you used to create account!',
                style: TextStyle(fontSize: 20, fontFamily: "times"),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.16,
            ),
            _form()
          ],
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: _phoneNumberField(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Text(
              error,
              style: const TextStyle(color: Colors.redAccent, fontSize: 16),
            ),
            const SizedBox(
              height: 6,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: _continueButton(),
            ),
          ],
        ));
  }

  // Phone number input field
  Widget _phoneNumberField() {
    return TextFormField(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.phone,
      controller: phoneNumberController,
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: 'Enter your phone number',
        hintStyle: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        suffixIcon: const Icon(
          Icons.phone_iphone_rounded,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.black38),
          gapPadding: 10,
        ),
        errorMaxLines: 2,
        errorStyle: const TextStyle(fontStyle: FontStyle.italic),
      ),
      validator: (value) {
        if (value!.length < 9 || value.length > 10) {
          return 'Phone number needs to be from 9 to 10 numbers';
        }
        return null;
      },
    );
  }

  // Button
  Widget _continueButton() {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(ForgotPasswordRepo()),
      child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) async {
          if (state is PhoneNumberExist) {
            String phone =
                phoneNumberController.text.replaceFirst(RegExp(r'0'), '');
            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: "+84$phone",
              verificationCompleted: (PhoneAuthCredential credential) {},
              verificationFailed: (FirebaseAuthException e) {
                log(e.message!);
              },
              codeSent: (String verificationId, int? resendToken) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpScreen(
                      verifyId: verificationId,
                      phoneNumber: phoneNumberController.text,
                      type: "Forgot",
                    ),
                  ),
                );
              },
              codeAutoRetrievalTimeout: (String verificationId) {},
            );
          }
          if (state is PhoneNumberNotExist) {
            setState(() {
              error = "No account found with given phone number";
            });
          }
        },
        child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              height: 40,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: const Color.fromRGBO(49, 147, 225, 1),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context
                        .read<ForgotPasswordBloc>()
                        .add(SubmitPhoneNumber(phoneNumberController.text));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Continue',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "times",
                          fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
