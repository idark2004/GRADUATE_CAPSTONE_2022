import 'package:apms_mobile/bloc/repositories/change_password_repo.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/change_password_bloc.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  String error = "";

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => ChangePasswordBloc(ChangePasswordRepo()),
        child: BlocListener<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) {
            if (state is PasswordChanged) {
              final snackBar = SnackBar(
              /// need to set following properties for best effect of awesome_snackbar_content
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Success',
                message: 'Your password has been changed',

                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                contentType: ContentType.success,
              ),
            );

            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
            Navigator.of(context).pop();
            }
            if (state is ChangePasswordError) {
              setState(() {
                error = state.error;
              });
            }
          },
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.1),
                    child: Builder(builder: (context) {
                      return _form(screenHeight);
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Form
  Widget _form(double screenHeight) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _oldPasswordField(),
            SizedBox(
              height: screenHeight * 0.06,
            ),
            _newPasswordField(),
            SizedBox(
              height: screenHeight * 0.06,
            ),
            _confirmPasswordField(),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            Text(
              error,
              style: const TextStyle(color: Colors.redAccent),
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            Builder(builder: (context) {
              return _continueButton();
            }),
          ],
        ),
      ),
    );
  }

  // Old Paasword input field
  Widget _oldPasswordField() {
    return TextFormField(
      obscureText: true,
      obscuringCharacter: "*",
      controller: oldPasswordController,
      decoration: InputDecoration(
        labelText: "Old Password",
        hintText: 'Enter your old password',
        hintStyle: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
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

  // New Paasword input field
  Widget _newPasswordField() {
    return TextFormField(
      obscureText: true,
      obscuringCharacter: "*",
      controller: newPasswordController,
      decoration: InputDecoration(
        labelText: "New Password",
        hintText: 'Enter your new password',
        hintStyle: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
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

  // Confirm Paasword input field
  Widget _confirmPasswordField() {
    return TextFormField(
      obscureText: true,
      obscuringCharacter: "*",
      decoration: InputDecoration(
        labelText: "Confirm Password",
        hintText: 'Confirm your new password',
        hintStyle: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
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
        if (value.toString() != newPasswordController.text) {
          return 'Confirm password does not match';
        }
        return null;
      },
    );
  }

  // Button
  Widget _continueButton() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
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
                context.read<ChangePasswordBloc>().add(
                      SubmittingPasswordChange(oldPasswordController.text,
                          newPasswordController.text),
                    );
              }
            },
            child: state is ChangingPassword
                ? const CircularProgressIndicator()
                : Row(
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
    );
  }
}
