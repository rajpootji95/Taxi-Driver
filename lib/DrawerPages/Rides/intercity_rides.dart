import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:why_taxi_driver/DrawerPages/Home/offline_page.dart';
import 'package:why_taxi_driver/DrawerPages/Rides/my_rides_page.dart';
import 'package:why_taxi_driver/DrawerPages/Rides/ride_info_page.dart';
import 'package:why_taxi_driver/Locale/strings_enum.dart';
import 'package:why_taxi_driver/Model/intercity_model.dart';
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

class IntercityRides extends StatefulWidget {
  bool selected;

  IntercityRides({this.selected = false});

  @override
  State<IntercityRides> createState() => _IntercityRidesState();
}

class _IntercityRidesState extends State<IntercityRides> {
  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool loading = true;
  List<IntercityRideModel> rideList = [];
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
          Uri.parse(baseUrl1 + "Payment/intercity_booking_driver"), params);
      setState(() {
        loading = false;
        rideList.clear();
      });
      if (response['status']) {
        print(response['data']);
        for (var v in response['data']) {
          setState(() {
            selectedFil = "All";
            rideList.add(IntercityRideModel.fromJson(v));
          });
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

    return Future.value();
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
            "Intercity Rides",
            style: theme.textTheme.headline4,
          ),
        ),
        body:  FadedSlideAnimation(
            child:
          SingleChildScrollView(
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
                                          rideList[index].adminCommision != null
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    text(
                                                        "${getTranslated(context, "Admincommission")} : ",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                    text(
                                                        "₹" +
                                                            "${rideList[index].adminCommision}",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                  ],
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
                                                  'Pickup City- ${rideList[index].pickupCity.toString()}',
                                                  style:
                                                      theme.textTheme.bodyText1,
                                                ),
                                                Text(
                                                  'Drop City- \u{20B9}${rideList[index].dropCity.toString()}',
                                                  style:
                                                      theme.textTheme.bodyText1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          ExpansionTile(
                                            initiallyExpanded: true,
                                            title: Text(
                                              'Trip ID- ${rideList[index].bookingId}',
                                              style: theme.textTheme.bodyText1,
                                            ),
                                            subtitle: Text(
                                              'Payment Method- ${rideList[index].transaction}',
                                              style: theme.textTheme.bodyText1,
                                            ),
                                            children: [
                                              Text("Click on check icon after pickup customer.",style: TextStyle(color: Colors.red),),
                                              if (rideList[index]
                                                      .shareUserData !=
                                                  null)
                                                for (int i = 0;
                                                    i <
                                                        rideList[index]
                                                            .shareUserData!
                                                            .length;
                                                    i++)
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 80,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 12,
                                                                  horizontal:
                                                                      16),
                                                          child: Row(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child:
                                                                    Container(
                                                                        height: getWidth(
                                                                            72),
                                                                        width: getWidth(
                                                                            72),
                                                                        decoration: boxDecoration(
                                                                            radius:
                                                                                10,
                                                                            color: Colors
                                                                                .grey),
                                                                        child: Image
                                                                            .network(
                                                                          imagePath +
                                                                              rideList[index].shareUserData![i].userImage.toString(),
                                                                          height:
                                                                              getWidth(72),
                                                                          width:
                                                                              getWidth(72),
                                                                        )),
                                                              ),
                                                              SizedBox(
                                                                  width: 16),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    getString1(rideList[
                                                                            index]
                                                                        .shareUserData![
                                                                            i]
                                                                        .username
                                                                        .toString()),
                                                                    style: theme
                                                                        .textTheme
                                                                        .bodyText1,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    '\u{20B9} ${rideList[index].shareUserData![i].totalAmount}',
                                                                    style: theme
                                                                        .textTheme
                                                                        .bodyText2!
                                                                        .copyWith(
                                                                            color:
                                                                                theme.primaryColor),
                                                                  ),
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                        showDialog(context: context, builder: (context)=>AlertDialog(
                                                                          title: Text("Confirmation"),
                                                                          content: Text("Do you want to confirm call?"),
                                                                          actions: [
                                                                            TextButton(onPressed: (){
                                                                              Navigator.pop(context);
                                                                            }, child: Text("Cancel")),
                                                                            TextButton(onPressed: (){
                                                                              Navigator.pop(context);
                                                                              launch(
                                                                                  "tel://${rideList[index].shareUserData![i].mobile}");
                                                                            }, child: Text("Confirm")),
                                                                          ],
                                                                        ));

                                                                  },
                                                                  icon: Icon(Icons
                                                                      .call)),
                                                              rideList[index]
                                                                          .shareUserData![
                                                                              i]
                                                                          .pickup_status
                                                                          .toString() !=
                                                                      "1"
                                                                  ? IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        showDialog(context: context, builder: (context)=>AlertDialog(
                                                                          title: Text("Confirmation"),
                                                                          content: Text("Do you want to confirm pickup?"),
                                                                          actions: [
                                                                            TextButton(onPressed: (){
                                                                              Navigator.pop(context);
                                                                            }, child: Text("Cancel")),
                                                                            TextButton(onPressed: (){
                                                                              Navigator.pop(context);
                                                                              pickupPerson(
                                                                                  rideList[index].bookingId!,
                                                                                  rideList[index].shareUserData![i].userId);
                                                                            }, child: Text("Confirm")),
                                                                          ],
                                                                        ));


                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .check))
                                                                  : SizedBox(),
                                                            ],
                                                          ),
                                                        ),
                                                        ListTile(
                                                          leading: Icon(
                                                            Icons.location_on,
                                                            color: theme
                                                                .primaryColor,
                                                            size: 20,
                                                          ),
                                                          trailing: IconButton(
                                                              onPressed: () {
                                                                String url =
                                                                    "https://www.google.com/maps/dir/?api=1&origin=${latitude.toString()},${longitude.toString()}&destination=${rideList[index].shareUserData![i].latitude},${rideList[index].shareUserData![i].longitude}&travelmode=driving&dir_action=navigate";
                                                                launch(url);
                                                                print(url);
                                                              },
                                                              icon: Icon(Icons
                                                                  .arrow_forward)),
                                                          title: Text(getString1(
                                                              rideList[index]
                                                                  .shareUserData![
                                                                      i]
                                                                  .pickupAddress
                                                                  .toString())),
                                                          dense: true,
                                                          tileColor:
                                                              theme.cardColor,
                                                        ),
                                                        ListTile(
                                                          leading: Icon(
                                                            Icons.navigation,
                                                            color: theme
                                                                .primaryColor,
                                                            size: 20,
                                                          ),
                                                          trailing: IconButton(
                                                              onPressed: () {
                                                                String url =
                                                                    "https://www.google.com/maps/dir/?api=1&origin=${latitude.toString()},${longitude.toString()}&destination=${rideList[index].shareUserData![i].dropLatitude},${rideList[index].shareUserData![i].dropLongitude}&travelmode=driving&dir_action=navigate";
                                                                launch(url);
                                                                print(url);
                                                              },
                                                              icon: Icon(Icons
                                                                  .arrow_forward)),
                                                          title: Text(getString1(
                                                              rideList[index]
                                                                  .shareUserData![
                                                                      i]
                                                                  .dropAddress
                                                                  .toString())),
                                                          dense: true,
                                                          tileColor:
                                                              theme.cardColor,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: AnimatedTextKit(
                                                  animatedTexts: [
                                                    ColorizeAnimatedText(
                                                      "Schedule - ${rideList[index].pickupDate} ${rideList[index].pickupTime}",
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
                                              ),
                                              const SizedBox(width: 8,),
                                              Expanded(
                                                child: AnimatedTextKit(
                                                  animatedTexts: [
                                                    ColorizeAnimatedText(
                                                      rideList[index]
                                                                  .shareingType
                                                                  .toString() !=
                                                              "1"
                                                          ? "Ride Type - Personal"
                                                          : "Ride Type - Sharing",
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
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Divider(),
                                          rideList[index].acceptReject != "3"
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    /*InkWell(
                                                      onTap: () {
                                                        String url =
                                                            "https://www.google.com/maps/dir/?api=1&origin=${latitude.toString()},${longitude.toString()}&destination=${rideList[index].latitude},${rideList[index].longitude}&travelmode=driving&dir_action=navigate";

                                                        print(url);
                                                        launch(url);
                                                      },
                                                      child: Container(
                                                        width: 30.w,
                                                        margin:
                                                            EdgeInsets.symmetric(
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
                                                    ),*/
                                                    InkWell(
                                                      onTap: () {
                                                        if (checkStatus(
                                                            index)) {
                                                          return;
                                                        }
                                                        if (rideList[index]
                                                                .acceptReject ==
                                                            "1") {
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
                                                            bgColor: checkStatus(
                                                                    index)
                                                                ? Colors.grey
                                                                : Theme.of(
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
                                              : SizedBox(),
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

  bool checkStatus(index) {
    for (int i = 0; i < rideList[index].shareUserData!.length; i++) {
      if (rideList[index].shareUserData![i].pickup_status.toString() != "1") {
        return true;
      }
    }
    return false;
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
        data = {
          "driver_id": curUserId,
          "accept_reject": status1.toString(),
          "booking_id": bookingId,
          "otp": otpController.text,
          "type": "intercity",
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
        } else {}
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

  startRide(String bookingId, status1, int index) async {
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

  pickupPerson(String bookingId, userId) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        setState(() {
          acceptStatus = true;
        });
        Map data;
        data = {
          "driver_id": curUserId,
          "booking_id": bookingId.toString(),
          "user_id": userId,
        };
        print("Start Ride ==== $data");
        // return;
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "Payment/pickup_user"), data);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        bool status = true;
        String msg = response['message'];
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

  startRideOtp(String bookingId, status1, int index) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        setState(() {
          acceptStatus = true;
        });
        Map data;
        data = {
          "driver_id": curUserId,
          "accept_reject": status1.toString(),
          "booking_id": bookingId,
          "type": "intercity",
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
