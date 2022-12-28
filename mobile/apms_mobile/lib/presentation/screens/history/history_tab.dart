import 'package:apms_mobile/presentation/screens/history/booking_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  final int selectedTab;
  const History({Key? key, this.selectedTab = 1}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.selectedTab,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10.0),
              child: TabBar(
                isScrollable: true,
                unselectedLabelColor: const Color.fromRGBO(49, 147, 225, 0.4),
                labelColor: const Color.fromRGBO(49, 147, 225, 1),
                labelPadding: const EdgeInsets.symmetric(horizontal: 30),
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(49, 147, 225, 1),
                      width: 2), // Indicator height
                  //insets: EdgeInsets.symmetric(horizontal: 48), // Indicator width
                ),
                tabs: tabs(),
              )),
        ),
        body: TabBarView(children: tabBarItems()),
      ),
    );
  }

  List<Widget> tabBarItems() {
    return const [
      BookingHistory(type: "Booking"), // Index : 0
      BookingHistory(type: "Parking"), // Index : 1
      BookingHistory(type: "Done"), // Index : 2
      BookingHistory(type: "Cancel"), // Index : 3
    ];
  }

  List<Widget> tabs() {
    return [
      Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(CupertinoIcons.ticket),
            Text('BOOKING'),
          ],
        ),
      ),
      Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(CupertinoIcons.clock),
            Text('PARKING'),
          ],
        ),
      ),
      Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(CupertinoIcons.check_mark),
            Text('DONE'),
          ],
        ),
      ),
      Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(CupertinoIcons.xmark_seal),
            Text('CANCELLED'),
          ],
        ),
      ),
    ];
  }
}

class RouteTab extends StatefulWidget {
  final int tabIndex;
  const RouteTab({Key? key, this.tabIndex = 1}) : super(key: key);

  @override
  State<RouteTab> createState() => _RouteTabState();
}

class _RouteTabState extends State<RouteTab> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
