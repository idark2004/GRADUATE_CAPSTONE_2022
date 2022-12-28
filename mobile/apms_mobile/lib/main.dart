// @dart=2.9

import 'package:apms_mobile/bloc/repositories/sign_up_repo.dart';
import 'package:apms_mobile/bloc/sign_up_bloc.dart';
import 'package:apms_mobile/presentation/screens/history/history_tab.dart';
import 'package:apms_mobile/presentation/screens/home/home.dart';
import 'package:apms_mobile/presentation/screens/authen/sign_in.dart';
import 'package:apms_mobile/presentation/screens/profile/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SignUpBloc(SignUpRepo()),
          ),
        ],
        child: Builder(builder: (context) {
          return const SignIn();
        }),
      ),
    ),
  );
}

class MyHome extends StatefulWidget {
  final int tabIndex;
  final int headerTabIndex;
  const MyHome({Key key, this.tabIndex = 0, this.headerTabIndex = 0})
      : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int pageIndex = 0;
  List<Widget> screens = [];
  @override
  void initState() {
    super.initState();
    screens = [
      const Home(),
      History(
        selectedTab: widget.headerTabIndex,
      ),
      const Profile(),
    ];
    pageIndex = widget.tabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Inter"),
      home: Scaffold(
        body: screens[pageIndex],
        bottomNavigationBar: buildMyNavBar(context),
      ),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                pageIndex = 0;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pageIndex == 0
                    ? Icon(
                        Icons.home,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      )
                    : const Icon(
                        Icons.home,
                        color: Color.fromARGB(255, 153, 213, 255),
                        size: 35,
                      ),
                Text(
                  'Home',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          pageIndex == 0 ? FontWeight.bold : FontWeight.normal,
                      color: pageIndex == 0
                          ? Theme.of(context).primaryColor
                          : const Color.fromARGB(255, 153, 213, 255)),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                pageIndex = 1;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pageIndex == 1
                    ? Icon(
                        Icons.history,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      )
                    : const Icon(
                        Icons.history,
                        color: Color.fromARGB(255, 153, 213, 255),
                        size: 35,
                      ),
                Text(
                  'History',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          pageIndex == 1 ? FontWeight.bold : FontWeight.normal,
                      color: pageIndex == 1
                          ? Theme.of(context).primaryColor
                          : const Color.fromARGB(255, 153, 213, 255)),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                pageIndex = 2;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pageIndex == 2
                    ? Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      )
                    : const Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 153, 213, 255),
                        size: 35,
                      ),
                Text(
                  'Profile',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          pageIndex == 2 ? FontWeight.bold : FontWeight.normal,
                      color: pageIndex == 2
                          ? Theme.of(context).primaryColor
                          : const Color.fromARGB(255, 153, 213, 255)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
