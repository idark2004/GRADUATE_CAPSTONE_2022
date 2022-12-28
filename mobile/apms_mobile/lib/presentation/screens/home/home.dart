import 'package:apms_mobile/bloc/car_park_bloc.dart';
import 'package:apms_mobile/themes/icons.dart';
import 'package:apms_mobile/themes/colors.dart';
import 'package:apms_mobile/presentation/screens/qr/qr_scan.dart';
import 'package:apms_mobile/utils/utils.dart';
import 'package:apms_mobile/models/car_park_model.dart';
import 'package:apms_mobile/presentation/screens/booking/booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CarParkBloc _carParkBloc = CarParkBloc();
  final CarParkBloc _carParkBloc2 = CarParkBloc();
  final _debouncer = Debouncer(milliseconds: 1000);
  Placemark? placemark = Placemark();
  CarParkSearchQuery searchQuery = CarParkSearchQuery();
  final List<CarParkModel> carParkList = [];
  List<CarParkModel> recentlyVisitedCarParkList = [];

  @override
  void initState() {
    _carParkBloc.add(const GetUserLocation());
    _carParkBloc2.add(GetRecentlyVisitedCarParkList());
    _carParkBloc.add(GetCarParkList(searchQuery));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: _buildUserLocation()),
        body: SingleChildScrollView(
            child: Column(children: [
          _buildRecentlyVisitedCarParkList(),
          _buildCarParkList()
        ])));
  }

  Widget _buildUserLocation() {
    return BlocProvider(
        create: (_) => _carParkBloc,
        child: BlocListener<CarParkBloc, CarParkState>(
            listener: (context, state) {
              if (state is CarParkSearchQueryUpdatedSuccessfully) {
                _carParkBloc.add(GetCarParkList(searchQuery));
              }
              if (state is UserLocationFetchedFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
                _carParkBloc.add(GetCarParkList(searchQuery));
              }
              if (state is UserLocationFetchedSuccessfully) {
                var queryData = {
                  "latitude": state.userLocation.latitude,
                  "longitude": state.userLocation.longitude
                };
                placemark = state.userPlacemark[0];
                _carParkBloc
                    .add(UpdateCarParkSearchQuery(searchQuery, queryData));
              }
            },
            child: BlocBuilder<CarParkBloc, CarParkState>(
                builder: ((context, state) => placemark?.street != null
                    ? AppBar(
                        backgroundColor: lightBlue,
                        title: Text(
                          "${placemark?.street}",
                          style: const TextStyle(fontSize: 12, color: deepBlue),
                        ),
                        leading: locationOnIcon,
                        actions: <Widget>[_buildQrButton(context)],
                        titleSpacing: -12,
                      )
                    : AppBar(
                        backgroundColor: lightBlue,
                        leading: locationOffIcon,
                        actions: <Widget>[_buildQrButton(context)],
                      )))));
  }

  Widget _buildSearchBar() {
    return SizedBox(
        height: 40,
        // child: DecoratedBox(
        //     decoration: BoxDecoration(
        //         border: Border(bottom: BorderSide(color: grey)), color: white),
        child: ListTile(
            leading: searchIcon,
            dense: true,
            contentPadding:
                const EdgeInsets.only(left: 10, bottom: 5, right: 40),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            horizontalTitleGap: 0,
            title: TextField(
              decoration: const InputDecoration(
                  hintStyle:
                      TextStyle(color: deepBlue, fontWeight: FontWeight.w700),
                  border: InputBorder.none,
                  hintText: "Search..."),
              onChanged: (value) => {
                _debouncer.run(() {
                  // Search func
                  _carParkBloc.add(
                      UpdateCarParkSearchQuery(searchQuery, {"name": value}));
                })
              },
            )));
  }

  Widget _buildRecentlyVisitedCarParkList() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(children: [
          const Padding(
              padding: EdgeInsets.only(right: 213),
              child: Text("Most Visited",
                  style:
                      TextStyle(color: deepBlue, fontWeight: FontWeight.w700))),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              width: 400,
              height: 75,
              child: BlocProvider(
                create: (_) => _carParkBloc2,
                child: BlocBuilder<CarParkBloc, CarParkState>(
                  builder: (context, state) {
                    if (state is RecentlyVisitedCarParkListFetching) {
                      return _buildLoading();
                    } else if (state
                        is RecentlyVisitedCarParkListFetchedSuccessfully) {
                      return _buildRecentlyVisitedCarParkCard(
                          context, state.recentlyVisitedCarParkList);
                    } else if (state is CarParkFetchedFailed) {
                      return Container();
                    } else {
                      return Container();
                    }
                  },
                ),
              ))
        ]));
  }

  Widget _buildRecentlyVisitedCarParkCard(
      BuildContext context, List<CarParkModel> recentlyVisitedCarParkList) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: recentlyVisitedCarParkList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Booking(carPark: recentlyVisitedCarParkList[index]))),
            child: Container(
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.only(
                    left: 10, right: 20, top: 15, bottom: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: lightGrey),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        recentlyVisitedCarParkList[index].name.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "Visited: ${recentlyVisitedCarParkList[index].visitCount} times")
                    ])),
          );
        });
  }

  Widget _buildCarParkList() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        child: SizedBox(
            height: 400,
            child: DecoratedBox(
                decoration: const BoxDecoration(
                    color: lightGrey,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: lightGrey,
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      )
                    ]),
                child: Column(children: [
                  SizedBox(
                      height: 50,
                      width: 400,
                      child: DecoratedBox(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              color: lightBlue),
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 20, 5),
                              child: _buildSearchBar()))),
                  Scrollbar(
                      child: SizedBox(
                    height: 350,
                    child: BlocProvider(
                      create: (_) => _carParkBloc,
                      child: BlocListener<CarParkBloc, CarParkState>(
                        listener: (context, state) {
                          if (state is CarParkFetchedFailed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message!),
                              ),
                            );
                          }
                        },
                        child: BlocBuilder<CarParkBloc, CarParkState>(
                          builder: (context, state) {
                            if (state is CarParkInitial) {
                              return _buildLoading();
                            } else if (state is CarParkFetching) {
                              return _buildLoading();
                            } else if (state is CarParkFetchedSuccessfully) {
                              return _buildCard(context, state.carParkList);
                            } else if (state is CarParkFetchedFailed) {
                              return Container();
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                  ))
                ]))));
  }

  Widget _buildCard(BuildContext context, List<CarParkModel> carParkList) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: carParkList.length,
      itemBuilder: (context, index) {
        CarParkModel carPark = carParkList[index];
        if (carPark.status) {
          return InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Booking(carPark: carPark))),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: grey))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      carPark.name.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Text(
                        "Address: ${carPark.addressNumber}, ${carPark.street}, ${carPark.district}, ${carPark.city} "),
                    Text("Available slots: ${carPark.availableSlotsCount}"),
                    const SizedBox(height: 10),
                    if (carPark.distance != null)
                      Row(children: [
                        distanceIcon,
                        Text("${carPark.distance!.toStringAsFixed(1)} km")
                      ])
                  ],
                ),
              ));
        } else {
          return Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                color: slightlyLightGrey,
                border: Border(bottom: BorderSide(color: grey))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  carPark.name.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Text(
                    "Address: ${carPark.addressNumber}, ${carPark.street}, ${carPark.district}, ${carPark.city} "),
                const SizedBox(height: 10),
                if (carPark.distance != null)
                  Row(children: [
                    
                    distanceIcon,
                    Text("${carPark.distance!.toStringAsFixed(1)} km")
                  ])
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  Widget _buildQrButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child:
            IconButton(onPressed: () => navigateToQR(context), icon: qrIcon));
  }

  // Navigate to the QR sacanner
  void navigateToQR(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const QRScan()));
  }
}
