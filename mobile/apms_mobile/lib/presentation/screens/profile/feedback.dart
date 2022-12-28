import 'package:apms_mobile/bloc/feedback_bloc.dart';
import 'package:apms_mobile/bloc/repositories/feedback_repo.dart';
import 'package:apms_mobile/utils/appbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendFeedback extends StatefulWidget {
  const SendFeedback({Key? key}) : super(key: key);

  @override
  State<SendFeedback> createState() => _SendFeedbackState();
}

class _SendFeedbackState extends State<SendFeedback> {
  TextEditingController textarea = TextEditingController();
  String error = '';
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBarBuilder().appBarDefaultBuilder("Feedback"),
      body: BlocProvider(
        create: (context) => FeedbackBloc(FeedbackRepo()),
        child: BlocListener<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackSent) {
              final snackBar = SnackBar(
                /// need to set following properties for best effect of awesome_snackbar_content
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Feedback sent!',
                  message: 'Thank you for your contribution',

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
            if (state is FeedbackError) {
              final snackBar = SnackBar(
                /// need to set following properties for best effect of awesome_snackbar_content
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Feedback error',
                  message: state.error,

                  /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                  contentType: ContentType.failure,
                ),
              );

              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          },
          child: BlocBuilder<FeedbackBloc, FeedbackState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, screenHeight * 0.1, 0, screenHeight * 0.1),
                          child: const Text(
                            'Please enter what you want to tell us!',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: textarea,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: "Enter your feedback",
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(49, 147, 225, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          if (textarea.text.isNotEmpty) {
                            context.read<FeedbackBloc>().add(
                                  SubmitFeedback(textarea.text),
                                );
                          } else {
                            setState(() {
                              error =
                                  "Please enter your opinion in the field above!";
                            });
                          }
                        },
                        child: state is SendingFeedback
                            ? const CircularProgressIndicator()
                            : const Text(
                                "Confirm",
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'times'),
                              ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
