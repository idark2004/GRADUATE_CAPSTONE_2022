import 'dart:async';

import 'package:apms_mobile/bloc/repositories/sign_up_repo.dart';
import 'package:apms_mobile/bloc/sign_up_bloc.dart';
import 'package:apms_mobile/presentation/screens/authen/forgot_password/create_new_password.dart';
import 'package:apms_mobile/presentation/screens/authen/sign_in.dart';
import 'package:apms_mobile/presentation/screens/authen/sign_up.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String fullName;
  final String password;
  final String verifyId;
  final String type;
  const OtpScreen(
      {Key? key,
      required this.phoneNumber,
      required this.verifyId,
      this.fullName = '',
      this.password = '',
      required this.type})
      : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FocusNode pin1FocusNode = FocusNode();
  FocusNode pin2FocusNode = FocusNode();
  FocusNode pin3FocusNode = FocusNode();
  FocusNode pin4FocusNode = FocusNode();
  FocusNode pin5FocusNode = FocusNode();
  FocusNode pin6FocusNode = FocusNode();

  int timeleft = 30;
  Map otp = {};
  String code = "";
  late Timer _timer;

  @override
  void initState() {
    if (mounted) {
      startCountDown();
    }
    super.initState();
  }

  @override
  void dispose() {
    pin1FocusNode.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
    _timer.cancel();
    super.dispose();
  }

// Timer
  void startCountDown() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (timeleft > 0) {
          setState(() {
            timeleft--;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  //Hide last 3 numbers of phone number
  String hidePhoneNumber(String phoneNumber) {
    String phone = phoneNumber.replaceFirst(RegExp(r'0'), '');
    String formatted = phone.substring(0, phoneNumber.length - 3);
    return "+84$formatted***";
  }

// Go to next input
  void nextField(
      {required String value,
      required int index,
      required FocusNode focusNode}) {
    otp[index] = value;
    if (otp.length < 6) {
      focusNode.requestFocus();
    } else {
      String value = "";
      for (var element in otp.values) {
        value = value + element;
      }
      code = value;
      focusNode.unfocus();
    }
  }

// Return to previous input
  void previousField({required int index, required FocusNode focusNode}) {
    otp.remove(index);
    focusNode.requestFocus();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => SignUpBloc(SignUpRepo()),
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(screenWidth * 0.06,
                    screenWidth * 0.12, screenWidth * 0.06, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'times',
                          fontSize: 36),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      'We sent your code to ${hidePhoneNumber(widget.phoneNumber)}',
                      style: const TextStyle(
                        fontFamily: 'times',
                        fontSize: 18,
                        color: Colors.black26,
                      ),
                      maxLines: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Get new code in '),
                        Text(
                            '00:${timeleft.toString().length > 1 ? timeleft.toString() : "0"}',
                            style: const TextStyle(
                                color: Color.fromRGBO(49, 147, 225, 1))),
                        TextButton(
                          onPressed: () {
                            if (timeleft == 0) {
                              setState(() {
                                timeleft = 16;
                                startCountDown();
                              });
                            } else {}
                          },
                          child: Text(
                            'Re-send',
                            style: TextStyle(
                                color: timeleft == 0
                                    ? const Color.fromRGBO(49, 147, 225, 1)
                                    : Colors.red),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenWidth * 0.1,
                    ),
                    _buildInput(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

//Input and submit button
  Form _buildInput() {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenWidth * 0.12,
                child: TextFormField(
                  focusNode: pin1FocusNode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: inputDecoration(),
                      border: inputDecoration()),
                  onChanged: (value) {
                    if (value.length == 1) {
                      nextField(
                          value: value, index: 0, focusNode: pin2FocusNode);
                    } else {
                      previousField(index: 0, focusNode: pin1FocusNode);
                    }
                  },
                ),
              ),
              SizedBox(
                width: screenWidth * 0.12,
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: inputDecoration(),
                      border: inputDecoration()),
                  onChanged: (value) {
                    if (value.length == 1) {
                      nextField(
                          value: value, index: 1, focusNode: pin3FocusNode);
                    } else {
                      previousField(index: 1, focusNode: pin1FocusNode);
                    }
                  },
                ),
              ),
              SizedBox(
                width: screenWidth * 0.12,
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: inputDecoration(),
                      border: inputDecoration()),
                  onChanged: (value) {
                    if (value.length == 1) {
                      nextField(
                          value: value, index: 2, focusNode: pin4FocusNode);
                    } else {
                      previousField(index: 2, focusNode: pin2FocusNode);
                    }
                  },
                ),
              ),
              SizedBox(
                width: screenWidth * 0.12,
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: inputDecoration(),
                      border: inputDecoration()),
                  onChanged: (value) {
                    if (value.length == 1) {
                      nextField(
                          value: value, index: 3, focusNode: pin5FocusNode);
                    } else {
                      previousField(index: 3, focusNode: pin3FocusNode);
                    }
                  },
                ),
              ),
              SizedBox(
                width: screenWidth * 0.12,
                child: TextFormField(
                  focusNode: pin5FocusNode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: inputDecoration(),
                      border: inputDecoration()),
                  onChanged: (value) {
                    if (value.length == 1) {
                      nextField(
                          value: value, index: 4, focusNode: pin6FocusNode);
                    } else {
                      previousField(index: 4, focusNode: pin4FocusNode);
                    }
                  },
                ),
              ),
              SizedBox(
                width: screenWidth * 0.12,
                child: TextFormField(
                  focusNode: pin6FocusNode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: inputDecoration(),
                      border: inputDecoration()),
                  onChanged: (value) {
                    if (value.length == 1) {
                      nextField(
                          value: value, index: 5, focusNode: pin6FocusNode);
                    } else {
                      previousField(index: 5, focusNode: pin5FocusNode);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          widget.type == "SignUp" ? signUpContinueButton() : forgotPasswordContinueButton(),
        ],
      ),
    );
  }

// Continue button
  Widget signUpContinueButton() {
    return BlocProvider(
      create: (context) => SignUpBloc(SignUpRepo()),
      child: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SignUp(),
              ),
            );
          }
          if (state is SignedUp) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Signed up Successfully'),
              ),
            );
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const SignIn(),
                ),
                (route) => false);
          }
        },
        child: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            if (state is SigningUp) {
              return _buildLoading();
            } else {
              final contextBloc = context.read<SignUpBloc>();
              return SizedBox(
                width: double.infinity,
                height: 40,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: const Color.fromRGBO(49, 147, 225, 1),
                  ),
                  onPressed: () async {
                    try {
                      // Create a PhoneAuthCredential with the code
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verifyId, smsCode: code);
                      // Sign the user in (or link) with the credential
                      final success =
                          await auth.signInWithCredential(credential);
                      if (success.user != null) {
                        contextBloc.add(
                          SignUpSubmiting(
                            widget.phoneNumber,
                            widget.password,
                            widget.fullName,
                          ),
                        );
                      }
                    // ignore: empty_catches
                    } catch (e) {
                    }
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                        color: Colors.white, fontFamily: "times", fontSize: 18),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

//Continue button for forgot password
  Widget forgotPasswordContinueButton() {
    final navigator = Navigator.of(context);
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
          try {
            // Create a PhoneAuthCredential with the code
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: widget.verifyId, smsCode: code);
            // Sign the user in (or link) with the credential
            final success = await auth.signInWithCredential(credential);
            if (success.user != null) {
              navigator.pushReplacement(MaterialPageRoute(
                builder: (context) => CreatePassword(phone: widget.phoneNumber),
              ));
            }
          // ignore: empty_catches
          } catch (e) {
          }
        },
        child: const Text(
          'Continue',
          style:
              TextStyle(color: Colors.white, fontFamily: "times", fontSize: 18),
        ),
      ),
    );
  }

  OutlineInputBorder inputDecoration() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.black38),
    );
  }

  // Loading circle
  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
