import 'package:apms_mobile/bloc/repositories/sign_up_repo.dart';
import 'package:apms_mobile/bloc/sign_up_bloc.dart';
import 'package:apms_mobile/presentation/screens/authen/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'component/header.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(SignUpRepo()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          bottom: MediaQuery.of(context).size.height * 0.04),
                      child: const Header(greeting: "Welcome!")),
                  _signupForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Form
  Widget _signupForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _fullnameField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            _phoneNumberField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            _passwordField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            _confirmPasswordField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            _continueButton(),
            //_loginButton(),
          ],
        ),
      ),
    );
  }

  // Phone number input field
  Widget _fullnameField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: fullNameController,
      decoration: InputDecoration(
        labelText: "Full Name",
        hintText: 'Enter your name',
        hintStyle: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        suffixIcon: const Icon(
          Icons.person,
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
        if (value!.length < 3) {
          return 'Name needs to be at least 3 characters';
        }
        return null;
      },
    );
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

// Paasword input field
  Widget _passwordField() {
    return TextFormField(
      obscureText: true,
      obscuringCharacter: "*",
      controller: passwordController,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: 'Enter your password',
        hintStyle: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        suffixIcon: const Icon(
          Icons.lock_outline_rounded,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.red),
          gapPadding: 10,
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
        if (value!.length < 8 || value.length > 10) {
          return 'Password needs to be from 8 to 10 characters';
        }
        return null;
      },
    );
  }

  // Confirm password input field
  Widget _confirmPasswordField() {
    return TextFormField(
      obscureText: true,
      obscuringCharacter: "*",
      decoration: InputDecoration(
        labelText: "Password",
        hintText: 'Confirm your password',
        hintStyle: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        suffixIcon: const Icon(
          Icons.lock_outline_rounded,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.red),
          gapPadding: 10,
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
        if (value.toString() != passwordController.text) {
          return 'Confirm password does not match';
        }
        return null;
      },
    );
  }

  // Button
  Widget _continueButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color.fromRGBO(49, 147, 225, 1),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            String phone =
                phoneNumberController.text.replaceFirst(RegExp(r'0'), '');
            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: "+84$phone",
              verificationCompleted: (PhoneAuthCredential credential) {},
              verificationFailed: (FirebaseAuthException e) {
              },
              codeSent: (String verificationId, int? resendToken) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpScreen(
                      verifyId: verificationId,
                      fullName: fullNameController.text,
                      password: passwordController.text,
                      phoneNumber: phoneNumberController.text,
                      type: "SignUp",
                    ),
                  ),
                );
              },
              codeAutoRetrievalTimeout: (String verificationId) {},
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Continue',
              style: TextStyle(
                  color: Colors.white, fontFamily: "times", fontSize: 18),
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
  }
}
