import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:why_taxi_driver/BookRide/payment_dailog.dart';
import 'package:why_taxi_driver/DrawerPages/Home/offline_page.dart';
import 'package:why_taxi_driver/DrawerPages/Rides/my_rides_page.dart';
import 'package:why_taxi_driver/DrawerPages/Rides/ride_info_page.dart';
import 'package:why_taxi_driver/Locale/strings_enum.dart';
import 'package:why_taxi_driver/Model/latlng_model.dart';
import 'package:why_taxi_driver/Model/my_ride_model.dart';
import 'package:why_taxi_driver/Model/rides_model.dart';
import 'package:why_taxi_driver/Routes/page_routes.dart';
import 'package:why_taxi_driver/Locale/locale.dart';
import 'package:why_taxi_driver/Theme/style.dart';
import 'package:why_taxi_driver/rental_ride_track.dart';
import 'package:why_taxi_driver/utils/ApiBaseHelper.dart';
import 'package:why_taxi_driver/utils/Session.dart';
import 'package:why_taxi_driver/utils/colors.dart';
import 'package:why_taxi_driver/utils/common.dart';
import 'package:why_taxi_driver/utils/constant.dart';
import 'package:why_taxi_driver/utils/location_details.dart';
import 'package:why_taxi_driver/utils/widget.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Assets/assets.dart';

class RentalRides extends StatefulWidget {
  bool selected;

  RentalRides({this.selected = false});

  @override
  State<RentalRides> createState() => _RentalRidesState();
}

class _RentalRidesState extends State<RentalRides> {
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = true;
  List<MyRideModel> rideList = [];
  String km = "0", time = "";
  int minute = 0;
  int? indexSelected;
  double driveLat = 0, driveLng = 0;
  Timer? timer;
  getRides(type) async {
    try {
      setState(() {
        loading = true;
      });
      Map params = {
        "driver_id": curUserId,
        "type": type,
      };
      print("GET ALL COMPLETE ========= $params");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Payment/rental_Bookint_by_driver_id"), params);
      setState(() {
        loading = false;
        rideList.clear();
      });
      if (response['status']) {
        print(response['data']);
        for (var v in response['data']) {
          setState(() {
            selectedFil = "All";
            rideList.add(MyRideModel.fromJson(v));
          });
        }
        if (type == "1") {
          indexSelected =
              rideList.indexWhere((element) => element.acceptReject == "6");
          if (indexSelected != -1) {
            getLocation();
          }
        }
      } else {
        setState(() {
          selectedFil = "All";
        });
        setSnackbar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something Went Wrong", context);
    }
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double lastLat = 0;
  getLocation() {
    GetLocation location = new  GetLocation(context,(result) async {
      if (mounted) {
        setState(() {
          print(indexSelected);
          latitude = latitudeTemp;
          longitude = longitudeTemp;
          if (indexSelected != null &&
              indexSelected != -1 &&
              rideList.length > 0&&!selected) {
            List<String> calTime =
                rideList[indexSelected!].start_time!.split(":");
            DateTime firstTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                int.parse(calTime[0]),
                int.parse(calTime[1]));
            print(calTime.toString());
            minute = DateTime.now().difference(firstTime).inMinutes;
            time = durationToString(
                DateTime.now().difference(firstTime).inMinutes);
          }
        });
        if (indexSelected != null &&
            indexSelected != -1 &&
            rideList.length > 0&&!selected) {
          Map data1 = {
            "booking_id": rideList[indexSelected!].bookingId.toString(),
          };
          Map response1 = await apiBase.postAPICall(
              Uri.parse(baseUrl1 + "Payment/driver_latitude_logitude"), data1);
          print(response1);
          List<LatLngModel> tempList = [];
          if (response1['status']) {
            for (var v in response1['booking_id']) {
              tempList.add(LatLngModel.fromJson(v));
            }
            double totalDistance = 0;
            for (var i = 0; i < tempList.length - 1; i++) {
              totalDistance += calculateDistance(tempList[i].lat,
                  tempList[i].lang, tempList[i + 1].lat, tempList[i + 1].lang);
            }
            km = totalDistance.toStringAsFixed(2);
            print("total" + totalDistance.toString());
          }
        }
        if (indexSelected != null && indexSelected != -1) {
          if (lastLat != latitude) {
            lastLat = latitude;
            apiBase.postAPICall(
                Uri.parse(
                    "https://alphataxi.productsalphawizz.com/api/Payment/driver_last_lat_lang"),
                {
                  "driver_id": curUserId,
                  "booking_id": rideList[indexSelected!].bookingId,
                  "lat": latitude.toString(),
                  "lang": longitude.toString(),
                }).then((value) {});
          }
        }
      }
    }, status: true);
    location.getLoc();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = widget.selected;
    if (widget.selected) {
      getRides("3");
    } else {
      getRides("1");
    }
  }

  bool selected = false;
  List<String> filter = ["All", "Today", "Weekly", "Monthly"];
  String selectedFil = "All";
  Future<bool> onWill() {
    Navigator.pop(context, true);
    /* Navigator.popUntil(
      context,
      ModalRoute.withName('/'),
    );*/
    /*Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SearchLocationPage()),
        (route) => false);*/

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: onWill,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: AppTheme.primaryColor,
          title: Text(
            getTranslated(context, "RENTAL_RIDES")!,
            style: theme.textTheme.headline4,
          ),
        ),
        body: FadedSlideAnimation(
          child: SingleChildScrollView(
            child: Column(
              children: [
                /*  Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  getTranslated(context,Strings.MY_RIDES)!,
                  style: theme.textTheme.headline4,
                ),
              ),*/
                /*  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    getTranslated(context,Strings.LIST_OF_RIDES_COMPLETED)!,
                    style:
                    theme.textTheme.bodyText2!.copyWith(color: theme.hintColor),
                  ),
                ),*/
                boxHeight(10),
                Container(
                  width: getWidth(322.1),
                  decoration: boxDecoration(
                    bgColor: Colors.white,
                    radius: 10,
                    showShadow: true,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selected = false;
                          });
                          getRides("1");
                        },
                        child: Container(
                          height: getHeight(49),
                          width: getWidth(160),
                          decoration: !selected
                              ? BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(52, 61, 164, 139),
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 8.0,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).primaryColor,
                                )
                              : BoxDecoration(),
                          child: Center(
                            child: text(
                              getTranslated(context, "upcoming")!,
                              fontFamily: fontSemibold,
                              fontSize: 11.sp,
                              textColor:
                                  !selected ? Colors.white : Color(0xff37778A),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selected = true;
                          });
                          getRides("3");
                        },
                        child: Container(
                          height: getHeight(49),
                          width: getWidth(160),
                          decoration: selected
                              ? BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(52, 61, 164, 139),
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 8.0,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).primaryColor,
                                )
                              : BoxDecoration(),
                          child: Center(
                            child: text(
                              getTranslated(context, "Completed")!,
                              fontFamily: fontSemibold,
                              fontSize: 11.sp,
                              textColor:
                                  selected ? Colors.white : Color(0xff37778A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                boxHeight(19),
                Wrap(
                  spacing: 3.w,
                  children: filter.map((e) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedFil = e.toString();
                        });
                        var now = new DateTime.now();
                        var now_1w = now.subtract(Duration(days: 7));
                        var now_1m =
                            new DateTime(now.year, now.month - 1, now.day);
                        if (selectedFil == "Today") {
                          for (int i = 0; i < rideList.length; i++) {
                            DateTime date = DateTime.parse(
                                rideList[i].createdDate.toString());
                            if (now.day == date.day &&
                                now.month == date.month) {
                              setState(() {
                                rideList[i].show = true;
                              });
                            } else {
                              setState(() {
                                rideList[i].show = false;
                              });
                            }
                          }
                        }
                        if (selectedFil == "Weekly") {
                          for (int i = 0; i < rideList.length; i++) {
                            DateTime date = DateTime.parse(
                                rideList[i].createdDate.toString());
                            if (now_1w.isBefore(date)) {
                              setState(() {
                                rideList[i].show = true;
                              });
                            } else {
                              setState(() {
                                rideList[i].show = false;
                              });
                            }
                          }
                        }
                        if (selectedFil == "Monthly") {
                          for (int i = 0; i < rideList.length; i++) {
                            DateTime date = DateTime.parse(
                                rideList[i].createdDate.toString());
                            if (now_1m.isBefore(date)) {
                              setState(() {
                                rideList[i].show = true;
                              });
                            } else {
                              setState(() {
                                rideList[i].show = false;
                              });
                            }
                          }
                        }
                        if (selectedFil == "All") {
                          for (int i = 0; i < rideList.length; i++) {
                            setState(() {
                              rideList[i].show = true;
                            });
                          }
                        }
                      },
                      child: Chip(
                        side: BorderSide(color: MyColorName.primaryLite),
                        backgroundColor: selectedFil == e
                            ? MyColorName.primaryLite
                            : Colors.transparent,
                        shadowColor: Colors.transparent,
                        label: text(e,
                            fontFamily: fontMedium,
                            fontSize: 10.sp,
                            textColor:
                            selectedFil == e ? Colors.white : Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                boxHeight(19),
                !loading
                    ? rideList.length > 0
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: rideList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => rideList[index]
                                    .show!
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) =>
                                              PaymentDialog(rideList[index],from: true,));
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             RentalRideInfoPage(rideList[index])));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(getWidth(10)),
                                      decoration: boxDecoration(
                                          radius: 10,
                                          bgColor: Colors.white,
                                          showShadow: true),
                                      child: Column(
                                        children: [

                                          indexSelected != null &&
                                                  indexSelected != -1 &&
                                                  indexSelected == index
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Time- $time/min.',
                                                        style: theme.textTheme
                                                            .bodyText1,
                                                      ),
                                                      Text(
                                                        'Km- $km/Km.',
                                                        style: theme.textTheme
                                                            .bodyText1,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Extra Time- \u{20B9}${rideList[index].extra_time_charge.toString()}/min.',
                                                  style:
                                                      theme.textTheme.bodyText1,
                                                ),
                                                Text(
                                                  'Extra Km- \u{20B9}${rideList[index].extra_km_charge.toString()}/Km.',
                                                  style:
                                                      theme.textTheme.bodyText1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Container(
                                            height: 90,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                      height: getWidth(72),
                                                      width: getWidth(72),
                                                      decoration: boxDecoration(
                                                          radius: 10,
                                                          color: Colors.grey),
                                                      child: Image.network(
                                                        imagePath +
                                                            rideList[index]
                                                                .userImage
                                                                .toString(),
                                                        height: getWidth(72),
                                                        width: getWidth(72),
                                                      )),
                                                ),
                                                SizedBox(width: 16),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Trip ID-${getString1(rideList[index].uneaqueId.toString())}',
                                                      style: theme
                                                          .textTheme.bodyText1,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      '${getDate(rideList[index].createdDate)}',
                                                      style: theme
                                                          .textTheme.bodySmall,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      getString1(rideList[index]
                                                          .username
                                                          .toString()),
                                                      style: theme
                                                          .textTheme.caption,
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '\u{20B9} ${rideList[index].amount}',
                                                      style: theme
                                                          .textTheme.bodyText2!
                                                          .copyWith(
                                                              color: theme
                                                                  .primaryColor),
                                                    ),
                                                    IconButton(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        onPressed: () {
                                                          launch(
                                                              "tel://${rideList[index].mobile}");
                                                        },
                                                        icon: Icon(Icons.call))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListTile(
                                            leading: Icon(
                                              Icons.location_on,
                                              color: theme.primaryColor,
                                              size: 20,
                                            ),
                                            title: Text(getString1(
                                                rideList[index]
                                                    .pickupAddress
                                                    .toString())),
                                            dense: true,
                                            tileColor: theme.cardColor,
                                          ),
                                          ListTile(
                                            leading: Icon(
                                              Icons.admin_panel_settings,
                                              color: theme.primaryColor,
                                              size: 20,
                                            ),
                                            title: Text(getString1(
                                                "Admin Commission - \u{20B9}${rideList[index].admin_commision.toString()}")),
                                            dense: true,
                                            tileColor: theme.cardColor,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AnimatedTextKit(
                                                animatedTexts: [
                                                  ColorizeAnimatedText(
                                                    rideList[index]
                                                            .bookingType
                                                            .toString()
                                                            .contains(
                                                                "Rental Booking")
                                                        ? "Rental Booking\n${rideList[index].start_time} - ${rideList[index].end_time}"
                                                        : "Schedule - ${rideList[index].pickupDate} ${rideList[index].pickupTime}",
                                                    textStyle:
                                                        colorizeTextStyle,
                                                    colors: colorizeColors,
                                                  ),
                                                ],
                                                pause:
                                                    Duration(milliseconds: 100),
                                                isRepeatingAnimation: true,
                                                totalRepeatCount: 100,
                                                onTap: () {
                                                  print("Tap Event");
                                                },
                                              ),
                                              AnimatedTextKit(
                                                animatedTexts: [
                                                  ColorizeAnimatedText(
                                                    rideList[index]
                                                            .bookingType
                                                            .toString()
                                                            .contains(
                                                                "Rental Booking")
                                                        ? "Allow Time/KM\n${rideList[index].hours}min. - ${rideList[index].km}KM"
                                                        : "",
                                                    textStyle:
                                                        colorizeTextStyle,
                                                    colors: colorizeColors,
                                                  ),
                                                ],
                                                pause:
                                                    Duration(milliseconds: 100),
                                                isRepeatingAnimation: true,
                                                totalRepeatCount: 100,
                                                onTap: () {
                                                  print("Tap Event");
                                                },
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                          rideList[index].acceptReject != "3"
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        String url =
                                                            "https://www.google.com/maps/dir/?api=1&origin=${latitude.toString()},${longitude.toString()}&destination=${rideList[index].latitude},${rideList[index].longitude}&travel_mode=driving&dir_action=navigate";

                                                        print(url);
                                                        launch(url);
                                                      },
                                                      child: Container(
                                                        width: 30.w,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 16),
                                                        height: 5.h,
                                                        decoration: boxDecoration(
                                                            radius: 5,
                                                            bgColor: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        child: Center(
                                                            child: loading1
                                                                ? text("Map",
                                                                    fontFamily:
                                                                        fontMedium,
                                                                    fontSize:
                                                                        10.sp,
                                                                    isCentered:
                                                                        true,
                                                                    textColor:
                                                                        Colors
                                                                            .white)
                                                                : CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          acceptStatus = true;
                                                        });
                                                        if (rideList[index]
                                                                .acceptReject ==
                                                            "1") {
                                                          print(
                                                              "this is booking id ${rideList[index].id!.toString()}");
                                                          DateTime startTime =
                                                              DateTime.now();
                                                          DateTime endTime =
                                                              DateFormat(
                                                                      'HH:mm:ss')
                                                                  .parse(rideList[
                                                                          index]
                                                                      .end_time
                                                                      .toString());
                                                          print(
                                                              "this is start time and end time ${startTime.toString()} ${endTime.toString()}");
                                                          Duration difference =
                                                              endTime.difference(
                                                                  startTime);
                                                          int differenceInMinutes =
                                                              difference
                                                                  .inMinutes;
                                                          print(
                                                              'Time difference in minutes: $differenceInMinutes');
                                                          startRide(
                                                              rideList[index]
                                                                  .bookingId!,
                                                              "6",
                                                              index);
                                                        } else {
                                                          print("complete");
                                                          completeRide(
                                                            rideList[index]
                                                                .bookingId!,
                                                            "3",
                                                            rideList[index]
                                                                .hours!,
                                                            rideList[index].km!,
                                                          );
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 30.w,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 16),
                                                        height: 5.h,
                                                        decoration: boxDecoration(
                                                            radius: 5,
                                                            bgColor: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        child: Center(
                                                            child: !acceptStatus
                                                                ? text(
                                                                    rideList[index].acceptReject ==
                                                                            "1"
                                                                        ? "Start"
                                                                        : "Complete",
                                                                    fontFamily:
                                                                        fontMedium,
                                                                    fontSize:
                                                                        10.sp,
                                                                    isCentered:
                                                                        true,
                                                                    textColor:
                                                                        Colors
                                                                            .white)
                                                                : CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    AnimatedTextKit(
                                                      animatedTexts: [
                                                        ColorizeAnimatedText(
                                                          rideList[index]
                                                                      .transaction !=
                                                                  null
                                                              ? "Payment Method - ${rideList[index].transaction}"
                                                              : "Payment Method - Wait",
                                                          textStyle:
                                                              colorizeTextStyle,
                                                          colors:
                                                              colorizeColors,
                                                        ),
                                                      ],
                                                      pause: Duration(
                                                          milliseconds: 100),
                                                      isRepeatingAnimation:
                                                          true,
                                                      totalRepeatCount: 100,
                                                      onTap: () {
                                                        print("Tap Event");
                                                      },
                                                    ),
                                                    AnimatedTextKit(
                                                      animatedTexts: [
                                                        ColorizeAnimatedText(
                                                          rideList[index]
                                                                      .payment_status
                                                                      .toString() !=
                                                                  "1"
                                                              ? "Payment Status - DONE"
                                                              : "Payment Status - Wait",
                                                          textStyle:
                                                              colorizeTextStyle,
                                                          colors:
                                                              colorizeColors,
                                                        ),
                                                      ],
                                                      pause: Duration(
                                                          milliseconds: 100),
                                                      isRepeatingAnimation:
                                                          true,
                                                      totalRepeatCount: 100,
                                                      onTap: () {
                                                        print("Tap Event");
                                                      },
                                                    ),
                                                  ],
                                                ),
                                          Padding(padding: EdgeInsets.all(8.0),child: Text("Tap For More Info"),),
                                          SizedBox(height: 12),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          )
                        : Center(
                            child: text(getTranslated(context, "Norides")!,
                                fontFamily: fontMedium,
                                fontSize: 12.sp,
                                textColor: Colors.black),
                          )
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      ),
    );
  }

  bool loading1 = true;
  bool acceptStatus = false;
  TextEditingController otpController = TextEditingController();
  bookingStatus(String bookingId, status1, hour, km1) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        int min1 = hour != null ? minute - int.parse(hour) : minute;
        double km2 = km1 != null
            ? double.parse(km) - double.parse(km1)
            : double.parse(km);
        data = {
          "driver_id": curUserId,
          "accept_reject": status1.toString(),
          "booking_id": bookingId,
          "otp": otpController.text,
          "type": "Rental Booking",
          "extra_time": min1.isNegative ? "0" : min1.toString(),
          "extra_distance": km2.isNegative ? "0" : km2.toStringAsFixed(2),
        };
        print("COMPLETE RIDE === $data");
        // return;
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "payment/complete_ride_driver"), data);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        bool status = true;
        String msg = response['message'];
        setSnackbar(msg, context);
        if (response['status']) {
          Navigator.pop(context);
          if (selected) {
            getRides("3");
          } else {
            getRides("1");
          }
        } else {
          Navigator.pop(context);
        }
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }

  completeRide(String bookingId, status1, hour, km) async {
    otpController.text = "";
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              // title: Text("Start Ride"),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Complete Ride",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text("Enter OTP given by user"),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15.0, right: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                          counterText: "",
                          hintText: "OTP here",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      controller: otpController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //       primary: Theme.of(context)
                        //           .primaryColor),
                        //   child: Text("Back",
                        //     style: TextStyle(
                        //         color: Colors.black
                        //     ),),
                        //   onPressed: () async{
                        //     // setState((){
                        //     //   acceptStatus = false;
                        //     // });
                        //    Navigator.pop(context);
                        //   },
                        // ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (otpController.text.isNotEmpty &&
                                otpController.text.length == 4) {
                              setState(() {
                                acceptStatus = false;
                              });
                              bookingStatus(bookingId, status1, hour, km);
                            } else {
                              setState(() {
                                acceptStatus = false;
                              });
                              Fluttertoast.showToast(msg: "OTP is required");
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              // actions: <Widget>[
              //   ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //         primary: Theme.of(context)
              //             .primaryColor
              //     ),
              //     child: Text("Submit"),
              //     onPressed: () async{
              //       startRideOtp(bookingId, status1);
              //     },
              //   ),
              //
              // ],
            ),
          );
        });
  }
  final colorizeTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w900,
    fontFamily: 'Inter',
  );
  startRide(String bookingId, status1, int index) async {
    otpController.text = "";
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              // title: Text("Start Ride"),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Start Ride",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text("Enter OTP given by user"),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15.0, right: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                          counterText: "",
                          hintText: "OTP here",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      controller: otpController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //       primary: Theme.of(context)
                        //           .primaryColor),
                        //   child: Text("Back",
                        //     style: TextStyle(
                        //         color: Colors.black
                        //     ),),
                        //   onPressed: () async{
                        //     // setState((){
                        //     //   acceptStatus = false;
                        //     // });
                        //    Navigator.pop(context);
                        //   },
                        // ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (otpController.text.isNotEmpty &&
                                otpController.text.length == 4) {
                              setState(() {
                                acceptStatus = false;
                              });
                              startRideOtp(bookingId, status1, index);
                            } else {
                              setState(() {
                                acceptStatus = false;
                              });
                              Fluttertoast.showToast(msg: "OTP is required");
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
              // actions: <Widget>[
              //   ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //         primary: Theme.of(context)
              //             .primaryColor
              //     ),
              //     child: Text("Submit"),
              //     onPressed: () async{
              //       startRideOtp(bookingId, status1);
              //     },
              //   ),
              //
              // ],
            ),
          );
        });
  }

  startRideOtp(String bookingId, status1, int index) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "driver_id": curUserId,
          "accept_reject": status1.toString(),
          "booking_id": bookingId,
          'otp': otpController.text.toString()
        };
        print("Start Ride ==== $data");
        // return;
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "Payment/start_ride"), data);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        bool status = true;
        String msg = response['message'];
        Navigator.pop(context);
        getRides("1");
        /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RentalRideInfoPage(rideList[index])));*/
        // Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
        setSnackbar(msg, context);
        if (response['status']) {
        } else {}
      } on TimeoutException catch (_) {
        setSnackbar("Something Went Wrong", context);
      }
    } else {
      setSnackbar("No Internet Connection", context);
    }
  }
}
