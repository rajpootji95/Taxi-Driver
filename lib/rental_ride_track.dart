// import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   late GoogleMapController _mapController;
//   late Position _position;
//   late Marker _marker;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     final position = await Geolocator.getCurrentPosition();
//     setState(() {
//       _position = position;
//       _marker = Marker(
//         markerId: MarkerId("user_location"),
//         position: LatLng(position.latitude, position.longitude),
//         infoWindow: InfoWindow(title: "Your location"),
//       );
//     });
//     _mapController.animateCamera(CameraUpdate.newLatLngZoom(
//         LatLng(position.latitude, position.longitude), 15));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Map"),
//       ),
//       body: _position == null
//           ? Center(child: CircularProgressIndicator())
//           : GoogleMap(
//         initialCameraPosition: CameraPosition(
//             target: LatLng(_position.latitude, _position.longitude),
//             zoom: 15),
//         onMapCreated: (controller) => _mapController = controller,
//         markers: Set.of([_marker]),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:why_taxi_driver/Components/row_item.dart';
import 'package:why_taxi_driver/DrawerPages/Home/offline_page.dart';
import 'package:why_taxi_driver/DrawerPages/Rides/my_rides_page.dart';
import 'package:why_taxi_driver/Model/my_ride_model.dart';
import 'package:why_taxi_driver/Model/reason_model.dart';
import 'package:why_taxi_driver/utils/ApiBaseHelper.dart';
import 'package:why_taxi_driver/utils/PushNotificationService.dart';
import 'package:why_taxi_driver/utils/Session.dart';
import 'package:why_taxi_driver/utils/colors.dart';
import 'package:why_taxi_driver/utils/common.dart';
import 'package:why_taxi_driver/utils/constant.dart';
import 'package:why_taxi_driver/utils/map.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'package:why_taxi_driver/utils/widget.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

Timer? timer;

class RentalRideInfoPage extends StatefulWidget {
  MyRideModel model;
  String? check;
  RentalRideInfoPage(this.model, {this.check});

  @override
  State<RentalRideInfoPage> createState() => _RentalRideInfoPageState();
}

class _RentalRideInfoPageState extends State<RentalRideInfoPage> {
  DateTime? currentBackPressTime;
  bool condition = false;

  late GoogleMapController _mapController;
  late Position _position;
  late Marker _marker;

  Future<bool> onWill() async {
    DateTime now = DateTime.now();
    if (widget.model.acceptReject != "1" ||
        !widget.model.bookingType.toString().contains("Point")) {
      Navigator.pop(context);
    } else {
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Common().toast("Can't Exit");
        return Future.value(false);
      }
    }
    //  exit(1);
    return Future.value();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    try {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    } on Exception catch (exception) {
      return 0; // only executed if error is of type Exception
    } catch (error) {
      return 0; // executed for errors of all types other than Exception
    }
  }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool acceptStatus = false;
  double distance = 0;
  TextEditingController otpController = TextEditingController();

  bookingStatus(String bookingId, status1) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        Map data1;

        data = {
          "driver_id": curUserId,
          "accept_reject": status1.toString(),
          "booking_id": bookingId,
        };

        data1 = {
          'user_id': '2',
          'username': 'Karan',
          'pickup_address':
              '151, Ward 35, Ratna Lok Colony, Indore, Madhya Pradesh 452010, India',
          'latitude': '22.746883699999998',
          'longitude': '75.8980128',
          'amount': 'null',
          'paid_amount': 'null',
          'gst_amount': '0.00',
          'surge_amount': '0.00',
          'taxi_type': '47',
          'cancel_charge': '50.00',
          'hours': '',
          'start_time': '5:36 PM',
          'end_time': '',
          'delivery_type': '2',
          'paymenttype': 'Cash',
          'taxi_id': '26',
          'transaction': 'Cash',
          'booking_id': '5'
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
        UI.setSnackBar(msg, context);
        if (response['status']) {
          Navigator.popUntil(
            context,
            ModalRoute.withName('/'),
          );
          /*Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => OfflinePage("")),
              (route) => false);*/
        } else {}
      } on TimeoutException catch (_) {
        UI.setSnackBar("Something Went Wrong", context);
      }
    } else {
      UI.setSnackBar("No Internet Connection", context);
    }
  }

  completeRentalRide(String bookingId, status1) async {
    print("this is distance =====>>>>> ${distance.toString()}");
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        Map data1;

        // data = {
        //   "driver_id": curUserId,
        //   "accept_reject": status1.toString(),
        //   "booking_id": bookingId,
        // };

        data1 = {
          'user_id': curUserId,
          'username': widget.model.username.toString(),
          'pickup_address': widget.model.pickupAddress.toString(),
          'latitude': widget.model.latitude.toString(),
          'longitude': widget.model.latitude.toString(),
          'amount': widget.model.amount.toString(),
          'paid_amount': widget.model.paidAmount.toString(),
          'gst_amount': widget.model.gstAmount.toString(),
          'surge_amount': widget.model.surgeAmount.toString(),
          'taxi_type': widget.model.taxiType.toString(),
          'cancel_charge': '20',
          'hours': '',
          'start_time': widget.model.start_time.toString(),
          'end_time': DateFormat.jm().format(DateTime.now()),
          'delivery_type': '2',
          'paymenttype': 'Cash',
          'taxi_id': '26',
          'transaction': 'Cash',
          'booking_id': widget.model.bookingId.toString(),
        };

        print("COMPLETE RIDE === $data1");
        // return;
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "Payment/complete_rental_ride"), data1);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        bool status = true;
        String msg = response['message'];
        UI.setSnackBar(msg, context);
        if (response['status']) {
          Navigator.popUntil(
            context,
            ModalRoute.withName('/'),
          );
          /*Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => OfflinePage("")),
              (route) => false);*/
        } else {}
      } on TimeoutException catch (_) {
        UI.setSnackBar("Something Went Wrong", context);
      }
    } else {
      UI.setSnackBar("No Internet Connection", context);
    }
  }

  startRideOtp(String bookingId, status1) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "driver_id": curUserId,
          "accept_reject": status1.toString(),
          "booking_id": bookingId,
          "otp": otpController.text.toString()
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
        UI.setSnackBar(msg, context);
        Navigator.pop(context);
        if (response['status']) {
          setState(() {
            widget.model.acceptReject = "6";
          });
        } else {}
      } on TimeoutException catch (_) {
        UI.setSnackBar("Something Went Wrong", context);
      }
    } else {
      UI.setSnackBar("No Internet Connection", context);
    }
  }

  startRide(String bookingId, status1) async {
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
                              startRideOtp(bookingId, status1);
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

  cancelStatus(String bookingId, status1) async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "driver_id": curUserId,
          "accept_reject": "5",
          "booking_id": bookingId,
          "reason": reasonList[indexReason].reason,
        };
        print("cancel_ride Ride ==== $data");
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "payment/cancel_ride_user_driver"), data);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        bool status = true;
        String msg = response['message'];
        UI.setSnackBar(msg, context);
        if (response['status']) {
          Navigator.popUntil(
            context,
            ModalRoute.withName('/'),
          );
          /*Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => OfflinePage("")),
              (route) => false);*/
        } else {}
      } on TimeoutException catch (_) {
        UI.setSnackBar("Something Went Wrong", context);
      }
    } else {
      UI.setSnackBar("No Internet Connection", context);
    }
  }

  List<ReasonModel> reasonList = [];

  getReason() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "type": "Driver",
        };
        print("cancel_ride Reason ==== $data");
        Map response = await apiBase.postAPICall(
            Uri.parse(baseUrl1 + "payment/cancel_ride_reason"), data);
        print(response);
        print(response);
        setState(() {
          acceptStatus = false;
        });
        bool status = true;
        String msg = response['message'];
        UI.setSnackBar(msg, context);
        if (response['status']) {
          for (var v in response['data']) {
            setState(() {
              reasonList.add(new ReasonModel.fromJson(v));
            });
          }
          //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> OfflinePage("")), (route) => false);
        } else {}
      } on TimeoutException catch (_) {
        UI.setSnackBar("Something Went Wrong", context);
      }
    } else {
      UI.setSnackBar("No Internet Connection", context);
    }
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _position = position;
      _marker = Marker(
        markerId: MarkerId("user_location"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: "Your location"),
      );
    });
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude), 15));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
    PushNotificationService pushNotificationService =
        new PushNotificationService(
            context: context,
            onResult: (result) {
              //if(mounted&&result=="yes")
              print("result" + result);
              if (result == "update") {
                getCurrentInfo();
              } else if (result == "cancelled") {
                getCurrentInfo();
              }
            });
    pushNotificationService.initialise();
    if (widget.check != null) {
      showMore = !showMore;
    } else {
      getReason();
    }
    /* Timer.periodic(const Duration(seconds: 10), (timer) {
      getCurrentInfo();
      if(condition) {
        timer.cancel();
      }
    });*/
  }

  bool saveStatus = true;
  getCurrentInfo() async {
    try {
      setState(() {
        saveStatus = false;
      });
      Map params = {
        "driver_id": curUserId,
      };
      print("GET DRIVER BOOKING RIDE ====== $params");
      Map response = await apiBase.postAPICall(
          Uri.parse(baseUrl1 + "Payment/get_driver_booking_ride"), params);
      setState(() {
        saveStatus = true;
      });
      if (response['status']) {
        var v = response["data"][0];
        setState(() {
          widget.model = MyRideModel.fromJson(v);
        });
        /* showConfirm(RidesModel(v['id'], v['user_id'], v['username'], v['uneaque_id'], v['purpose'], v['pickup_area'],
            v['pickup_date'], v['drop_area'], v['pickup_time'], v['area'], v['landmark'], v['pickup_address'], v['drop_address'],
            v['taxi_type'], v['departure_time'], v['departure_date'], v['return_date'], v['flight_number'], v['package'],
            v['promo_code'], v['distance'], v['amount'], v['paid_amount'], v['address'], v['transfer'], v['item_status'],
            v['transaction'], v['payment_media'], v['km'], v['timetype'], v['assigned_for'], v['is_paid_advance'], v['status'], v['latitude'], v['longitude'], v['date_added'],
            v['drop_latitude'], v['drop_longitude'], v['booking_type'], v['accept_reject'], v['created_date']));*/

        //print(data);
      } else {
        setState(() {
          condition = true;
        });
        Navigator.popUntil(
          context,
          ModalRoute.withName('/'),
        );
        /*Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OfflinePage("")));*/
        UI.setSnackBar("Ride is Canceller By user", context);
      }
    } on TimeoutException catch (_) {
      UI.setSnackBar("Something Went Wrong", context);
      setState(() {
        saveStatus = true;
      });
    }
  }

  bool showMore = false;
  int indexReason = 0;
  PersistentBottomSheetController? persistentBottomSheetController1;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  showBottom1() async {
    persistentBottomSheetController1 =
        await scaffoldKey.currentState!.showBottomSheet((context) {
      return Container(
        decoration:
            boxDecoration(radius: 0, showShadow: true, color: Colors.white),
        padding: EdgeInsets.all(getWidth(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            boxHeight(20),
            text("Select Reason",
                textColor: MyColorName.colorTextPrimary,
                fontSize: 12.sp,
                fontFamily: fontBold),
            boxHeight(20),
            reasonList.length > 0
                ? Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: reasonList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              persistentBottomSheetController1!.setState!(() {
                                indexReason = index;
                              });
                              // Navigator.pop(context);
                            },
                            child: Container(
                              color: indexReason == index
                                  ? MyColorName.primaryLite.withOpacity(0.2)
                                  : Colors.white,
                              padding: EdgeInsets.all(getWidth(10)),
                              child: text(reasonList[index].reason.toString(),
                                  textColor: MyColorName.colorTextPrimary,
                                  fontSize: 10.sp,
                                  fontFamily: fontMedium,
                                  isLongText: true),
                            ),
                          );
                        }),
                  )
                : SizedBox(),
            boxHeight(20),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: !acceptStatus
                      ? Container(
                          width: 35.w,
                          height: 5.h,
                          margin: EdgeInsets.all(getWidth(14)),
                          decoration: boxDecoration(
                              radius: 5,
                              bgColor: Theme.of(context).primaryColor),
                          child: Center(
                              child: text("Back",
                                  fontFamily: fontMedium,
                                  fontSize: 10.sp,
                                  isCentered: true,
                                  textColor: Colors.white)),
                        )
                      : CircularProgressIndicator(),
                ),
                boxWidth(10),
                InkWell(
                  onTap: () {
                    persistentBottomSheetController1!.setState!(() {
                      acceptStatus = true;
                    });
                    cancelStatus(widget.model.bookingId!, "5");
                  },
                  child: !acceptStatus
                      ? Container(
                          width: 35.w,
                          height: 5.h,
                          margin: EdgeInsets.all(getWidth(14)),
                          decoration: boxDecoration(
                              radius: 5,
                              bgColor: Theme.of(context).primaryColor),
                          child: Center(
                              child: text("Continue",
                                  fontFamily: fontMedium,
                                  fontSize: 10.sp,
                                  isCentered: true,
                                  textColor: Colors.white)),
                        )
                      : CircularProgressIndicator(),
                ),
              ],
            ),
            boxHeight(40),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        "USER IMAGE====== $imagePath${widget.model.userImage.toString().split("/").last}");
    var theme = Theme.of(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWill,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          body: saveStatus
              ? widget.check == null
                  ? Container(
                      child: widget.model.latitude != null
                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                MapPage(
                                  true,
                                  pick: widget.model.pickupAddress.toString(),
                                  dest: widget.model.dropAddress.toString(),
                                  live: widget.model.acceptReject == "1" ||
                                          widget.model.acceptReject == "6"
                                      ? true
                                      : false,
                                  SOURCE_LOCATION: LatLng(
                                      double.parse(
                                          widget.model.latitude.toString()),
                                      double.parse(
                                          widget.model.longitude.toString())),
                                  DEST_LOCATION: LatLng(
                                      double.parse(
                                          _position.latitude.toString()),
                                      double.parse(
                                          _position.longitude.toString())),
                                ),
                                widget.model.acceptReject == "1" ||
                                        widget.model.acceptReject == "6"
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              launch(
                                                  "tel://${widget.model.mobile}");
                                            },
                                            child: Container(
                                              width: 28.w,
                                              height: 5.h,
                                              decoration: boxDecoration(
                                                  radius: 5,
                                                  bgColor: Theme.of(context)
                                                      .primaryColor),
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.call,
                                                    color: Colors.black,
                                                  ),
                                                  boxWidth(5),
                                                  text("Call",
                                                      fontFamily: fontMedium,
                                                      fontSize: 10.sp,
                                                      isCentered: true,
                                                      textColor: Colors.black),
                                                ],
                                              )),
                                            ),
                                          ),
                                          boxWidth(10),
                                          InkWell(
                                            onTap: () {
                                              showBottom1();
                                            },
                                            child: Container(
                                              width: 28.w,
                                              height: 5.h,
                                              decoration: boxDecoration(
                                                  radius: 5,
                                                  bgColor: Theme.of(context)
                                                      .primaryColor),
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                  ),
                                                  boxWidth(5),
                                                  text("Cancel",
                                                      fontFamily: fontMedium,
                                                      fontSize: 10.sp,
                                                      isCentered: true,
                                                      textColor: Colors.black),
                                                ],
                                              )),
                                            ),
                                          ),
                                          boxWidth(10),
                                          // !widget.model.bookingType!.contains("Point")?getDifference()?
                                          // InkWell(
                                          //     onTap: () {
                                          //       // setState(() {
                                          //       //   acceptStatus = true;
                                          //       // });
                                          //       if(widget.model.acceptReject=="1"){
                                          //         startRide(widget.model.bookingId!, "6");
                                          //       }else{
                                          //         print("complete");
                                          //         bookingStatus(widget.model.bookingId!, "3");
                                          //       }
                                          //     },
                                          //     child:
                                          //     // !acceptStatus?
                                          //     Container(
                                          //       width: 28.w,
                                          //       height: 5.h,
                                          //       decoration: boxDecoration(
                                          //           radius: 5,
                                          //           bgColor: Theme.of(context)
                                          //               .primaryColor),
                                          //       child: Center(
                                          //           child: Row(
                                          //             mainAxisAlignment: MainAxisAlignment.center,
                                          //             children: [
                                          //               Icon(Icons.check,color: Colors.black,),
                                          //               boxWidth(5),
                                          //               text( widget.model.acceptReject=="1" ? "Start" : "Complete",
                                          //                   fontFamily: fontMedium,
                                          //                   fontSize: 10.sp,
                                          //                   isCentered: true,
                                          //                   textColor: Colors.black),
                                          //             ],
                                          //           )),
                                          //     )
                                          //   // :CircularProgressIndicator(),
                                          // ):SizedBox():
                                          InkWell(
                                            onTap: () {
                                              _getCurrentLocation();
                                              DateTime endTime = DateTime.now();
                                              DateTime startTime =
                                                  DateFormat('HH:mm:ss').parse(
                                                      widget.model.start_time
                                                          .toString());
                                              print(
                                                  "this is start time and end time ${startTime.toString()} ${endTime.toString()}");
                                              Duration difference =
                                                  endTime.difference(startTime);
                                              int differenceInMinutes =
                                                  difference.inMinutes;
                                              print(
                                                  'Time difference in minutes: $differenceInMinutes');
                                              /*setState(() {
                          acceptStatus = true;
                        });*/
                                              // if(widget.model.acceptReject=="1"){
                                              //   /*setState(() {
                                              //     widget.model.acceptReject="6";
                                              //   });*/
                                              //   startRide(widget.model.bookingId!, "6");
                                              // }else{
                                              print("complete");
                                              distance = calculateDistance(
                                                  widget.model.latitude,
                                                  widget.model.longitude,
                                                  _position.latitude,
                                                  _position.longitude);
                                              completeRentalRide(
                                                  widget.model.bookingId!, "3");
                                              // bookingStatus(widget.model.bookingId!, "3");
                                              // }
                                            },
                                            child: !acceptStatus
                                                ? Container(
                                                    width: 28.w,
                                                    height: 5.h,
                                                    decoration: boxDecoration(
                                                        radius: 5,
                                                        bgColor:
                                                            Theme.of(context)
                                                                .primaryColor),
                                                    child: Center(
                                                        child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.check,
                                                          color: Colors.black,
                                                        ),
                                                        boxWidth(5),
                                                        text("Complete",
                                                            fontFamily:
                                                                fontMedium,
                                                            fontSize: 10.sp,
                                                            isCentered: true,
                                                            textColor:
                                                                Colors.black),
                                                      ],
                                                    )),
                                                  )
                                                : CircularProgressIndicator(),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ],
                            )
                          : SizedBox(),
                    )
                  : Container(
                      color: Colors.white,
                      height: double.infinity,
                      child: Column(
                        mainAxisSize: widget.check != null
                            ? MainAxisSize.max
                            : MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            padding: EdgeInsets.all(getWidth(10)),
                            decoration: BoxDecoration(
                              color: theme.backgroundColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    decoration: boxDecoration(
                                        radius: 12, color: Colors.grey),
                                    child: Image.network(
                                      "$imagePath${widget.model.userImage1.toString().split("/").last}",
                                      height: getWidth(72),
                                      width: getWidth(72),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.model.username.toString(),
                                      style: theme.textTheme.headline6,
                                    ),
                                    Spacer(flex: 2),
                                    Text(
                                      getTranslated(context, "BOOKED_ON")!,
                                      style: theme.textTheme.caption,
                                    ),
                                    Spacer(),
                                    Text(
                                      '${widget.model.dateAdded}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Text(
                                      'Trip ID-${getString1(widget.model.uneaqueId.toString())}',
                                      style: theme.textTheme.titleSmall,
                                    ),
                                    widget.check == null
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                showMore = !showMore;
                                              });
                                            },
                                            child: Container(
                                              width: 20.w,
                                              height: 4.h,
                                              margin:
                                                  EdgeInsets.all(getWidth(5)),
                                              decoration: boxDecoration(
                                                  radius: 5,
                                                  bgColor: Theme.of(context)
                                                      .primaryColor),
                                              child: Center(
                                                  child: text(
                                                      !showMore
                                                          ? "View More"
                                                          : "View Less",
                                                      fontFamily: fontMedium,
                                                      fontSize: 8.sp,
                                                      isCentered: true,
                                                      textColor: Colors.white)),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),

                                /*GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, PageRoutes.reviewsPage);
                                },
                                child: Container(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: AppTheme.ratingsColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Text('4.2'),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.star,
                                        color: AppTheme.starColor,
                                        size: 14,
                                      )
                                    ],
                                  ),
                                ),
                              ),*/
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          showMore
                              ? Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: theme.backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              getTranslated(
                                                  context, "RIDE_INFO")!,
                                              style: theme.textTheme.headline6!
                                                  .copyWith(
                                                      color: theme.hintColor,
                                                      fontSize: 18),
                                            ),
                                            trailing: Text(
                                                '${widget.model.km} km',
                                                style: theme
                                                    .textTheme.headline6!
                                                    .copyWith(fontSize: 18)),
                                          ),
                                          ListTile(
                                            leading: Icon(
                                              Icons.location_on,
                                              color: theme.primaryColor,
                                            ),
                                            title: Text(
                                                '${widget.model.pickupAddress}'),
                                          ),
                                          ListTile(
                                            leading: Icon(
                                              Icons.navigation,
                                              color: theme.primaryColor,
                                            ),
                                            title: Text(
                                                '${widget.model.dropAddress}'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                          color: theme.backgroundColor,
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16))),
                                      child: Row(
                                        children: [
                                          RowItem(
                                              getTranslated(
                                                  context, "PAYMENT_VIA"),
                                              '${widget.model.transaction}',
                                              Icons.account_balance_wallet),
                                          // Spacer(),
                                          RowItem(
                                              getTranslated(
                                                  context, "RIDE_FARE"),
                                              '\u{20B9} ${widget.model.amount}',
                                              Icons.account_balance_wallet),
                                          // Spacer(),
                                          RowItem(
                                              getTranslated(
                                                  context, "RIDE_TYPE"),
                                              '${widget.model.bookingType}',
                                              Icons.drive_eta),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(getWidth(15)),
                                      child: Column(
                                        children: [
                                          double.parse(widget.model.gstAmount
                                                      .toString()) >
                                                  0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    text("Sub Total : ",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                    text(
                                                        "₹" +
                                                            (double.parse(widget
                                                                        .model
                                                                        .amount
                                                                        .toString()) -
                                                                    double.parse(widget
                                                                        .model
                                                                        .gstAmount
                                                                        .toString()) -
                                                                    double.parse(widget
                                                                        .model
                                                                        .surgeAmount
                                                                        .toString()))
                                                                .toStringAsFixed(
                                                                    2),
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                  ],
                                                )
                                              : SizedBox(),
                                          double.parse(widget.model.baseFare
                                                      .toString()) >
                                                  0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    text("Base fare : ",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontRegular,
                                                        textColor:
                                                            Colors.black),
                                                    text(
                                                        "₹" +
                                                            widget
                                                                .model.baseFare
                                                                .toString(),
                                                        fontSize: 10.sp,
                                                        fontFamily: fontRegular,
                                                        textColor:
                                                            Colors.black),
                                                  ],
                                                )
                                              : SizedBox(),
                                          double.parse(widget.model.km
                                                          .toString()) >=
                                                      2 &&
                                                  double.parse(widget
                                                          .model.ratePerKm
                                                          .toString()) >
                                                      0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    text(
                                                        "${widget.model.km.toString()} Kilometers : ",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontRegular,
                                                        textColor:
                                                            Colors.black),
                                                    text(
                                                        "₹" +
                                                            widget
                                                                .model.ratePerKm
                                                                .toString(),
                                                        fontSize: 10.sp,
                                                        fontFamily: fontRegular,
                                                        textColor:
                                                            Colors.black),
                                                  ],
                                                )
                                              : SizedBox(),
                                          double.parse(widget.model.timeAmount
                                                      .toString()) >
                                                  0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    text(
                                                        "${widget.model.totalTime.toString()} Minutes : ",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontRegular,
                                                        textColor:
                                                            Colors.black),
                                                    text(
                                                        "₹" +
                                                            widget.model
                                                                .timeAmount
                                                                .toString(),
                                                        fontSize: 10.sp,
                                                        fontFamily: fontRegular,
                                                        textColor:
                                                            Colors.black),
                                                  ],
                                                )
                                              : SizedBox(),
                                          double.parse(widget.model.gstAmount
                                                      .toString()) >
                                                  0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    text("Taxes : ",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                    text(
                                                        "₹" +
                                                            widget
                                                                .model.gstAmount
                                                                .toString(),
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                  ],
                                                )
                                              : SizedBox(),
                                          double.parse(widget.model.surgeAmount
                                                      .toString()) >
                                                  0
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    text("Surge Amount : ",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                    text(
                                                        "₹" +
                                                            widget.model
                                                                .surgeAmount
                                                                .toString(),
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                  ],
                                                )
                                              : SizedBox(),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              text("Total : ",
                                                  fontSize: 10.sp,
                                                  fontFamily: fontMedium,
                                                  textColor: Colors.black),
                                              text(
                                                  "₹" +
                                                      "${widget.model.amount}",
                                                  fontSize: 10.sp,
                                                  fontFamily: fontMedium,
                                                  textColor: Colors.black),
                                            ],
                                          ),
                                          widget.model.admin_commision != null
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
                                                            "${widget.model.admin_commision}",
                                                        fontSize: 10.sp,
                                                        fontFamily: fontMedium,
                                                        textColor:
                                                            Colors.black),
                                                  ],
                                                )
                                              : SizedBox(),
                                          boxHeight(10),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ],
                      ),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          bottomNavigationBar: widget.check == null
              ? SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // !widget.model.bookingType!.contains("Point")?
                        // AnimatedTextKit(
                        //   animatedTexts: [
                        //     ColorizeAnimatedText(
                        //       "Schedule - ${widget.model.pickupDate} ${widget.model.pickupTime}",
                        //       textStyle: colorizeTextStyle,
                        //       colors: colorizeColors,
                        //     ),
                        //   ],
                        //   pause: Duration(milliseconds: 100),
                        //   isRepeatingAnimation: true,
                        //   totalRepeatCount: 100,
                        //   onTap: () {
                        //     print("Tap Event");
                        //   },
                        // ):SizedBox(),
                        Container(
                          height: 100,
                          padding: EdgeInsets.all(getWidth(10)),
                          decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: getWidth(72),
                                  width: getWidth(72),
                                  decoration: boxDecoration(
                                      radius: 12, color: Colors.grey),
                                  child: Image.network(
                                    "$imagePath${widget.model.userImage1.toString().split("/").last}",
                                    height: getWidth(72),
                                    width: getWidth(72),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.model.username.toString(),
                                      style: theme.textTheme.headline6,
                                    ),
                                    Spacer(flex: 2),
                                    Text(
                                      getTranslated(context, "BOOKED_ON")!,
                                      style: theme.textTheme.caption,
                                    ),
                                    Spacer(),
                                    Text(
                                      '${widget.model.dateAdded}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                    'Trip ID-${getString1(widget.model.uneaqueId.toString())}',
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  boxHeight(10),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showMore = !showMore;
                                      });
                                    },
                                    child: Container(
                                      width: 20.w,
                                      height: 4.h,
                                      margin: EdgeInsets.all(getWidth(5)),
                                      decoration: boxDecoration(
                                          radius: 5,
                                          bgColor:
                                              Theme.of(context).primaryColor),
                                      child: Center(
                                          child: text(
                                              !showMore
                                                  ? "View More"
                                                  : "View Less",
                                              fontFamily: fontMedium,
                                              fontSize: 8.sp,
                                              isCentered: true,
                                              textColor: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                              /*GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, PageRoutes.reviewsPage);
                                  },
                                  child: Container(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppTheme.ratingsColor,
                                    ),
                                    child: Row(
                                      children: [
                                        Text('4.2'),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.star,
                                          color: AppTheme.starColor,
                                          size: 14,
                                        )
                                      ],
                                    ),
                                  ),
                                ),*/
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        showMore
                            ? Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: theme.backgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            getTranslated(
                                                context, "RIDE_INFO")!,
                                            style: theme.textTheme.headline6!
                                                .copyWith(
                                                    color: theme.hintColor,
                                                    fontSize: 18),
                                          ),
                                          // trailing: Text('${widget.model.km} km',
                                          //     style: theme.textTheme.headline6!
                                          //         .copyWith(fontSize: 18)),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.location_on,
                                            color: theme.primaryColor,
                                          ),
                                          title: Text(
                                              '${widget.model.pickupAddress}'),
                                        ),
                                        // ListTile(
                                        //   leading: Icon(
                                        //     Icons.navigation,
                                        //     color: theme.primaryColor,
                                        //   ),
                                        //   title: Text('${widget.model.dropAddress}'),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: theme.backgroundColor,
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16))),
                                    child: Row(
                                      children: [
                                        // RowItem(
                                        //     getTranslated(context,"PAYMENT_VIA"),
                                        //     '${widget.model.transaction}',
                                        //     Icons.account_balance_wallet),
                                        // Spacer(),
                                        RowItem(
                                            getTranslated(context, "RIDE_FARE"),
                                            '\u{20B9} ${widget.model.amount}',
                                            Icons.account_balance_wallet),
                                        // Spacer(),
                                        RowItem(
                                            getTranslated(context, "RIDE_TYPE"),
                                            '${widget.model.bookingType}',
                                            Icons.drive_eta),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(getWidth(15)),
                                    child: Column(
                                      children: [
                                        // double.parse(widget.model.gstAmount.toString())>0?Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     text("Sub Total : ",
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontMedium,
                                        //         textColor: Colors.black),
                                        //     text(
                                        //         "₹" + (double.parse(widget.model.amount.toString())-double.parse(widget.model.gstAmount.toString())-double.parse(widget.model.surgeAmount.toString())).toStringAsFixed(2),
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontMedium,
                                        //         textColor: Colors.black),
                                        //   ],
                                        // ):SizedBox(),
                                        // double.parse(widget.model.baseFare.toString())>0?Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     text("Base fare : ",
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontRegular,
                                        //         textColor: Colors.black),
                                        //     text(
                                        //         "₹" + widget.model.baseFare.toString(),
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontRegular,
                                        //         textColor: Colors.black),
                                        //   ],
                                        // ):SizedBox(),
                                        // double.parse(widget.model.km.toString()) >=1 ?
                                        // double.parse(widget.model.ratePerKm.toString())>0? Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     text("${widget.model.km.toString()} Kilometers : ",
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontRegular,
                                        //         textColor: Colors.black),
                                        //     text(
                                        //         "₹" + widget.model.ratePerKm.toString(),
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontRegular,
                                        //         textColor: Colors.black),
                                        //   ],
                                        // ):SizedBox()
                                        //     : SizedBox.shrink(),
                                        // widget.model.promoDiscount.toString() == null || widget.model.promoDiscount.toString() == ''?
                                        // SizedBox.shrink() :
                                        // double.parse(widget.model.promoDiscount.toString())>0?Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     text("Promo Discount : ",
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontRegular,
                                        //         textColor: Colors.black),
                                        //     text(
                                        //         "-₹" + widget.model.promoDiscount.toString(),
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontRegular,
                                        //         textColor: Colors.black),
                                        //   ],
                                        // ):SizedBox(),
                                        // double.parse(widget.model.timeAmount.toString())>0?Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     text("${widget.model.totalTime.toString()} Minutes : ",
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontRegular,
                                        //         textColor: Colors.black),
                                        //     text(
                                        //         "₹" + widget.model.timeAmount.toString(),
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontRegular,
                                        //         textColor: Colors.black),
                                        //   ],
                                        // ):SizedBox(),
                                        // double.parse(widget.model.gstAmount.toString())>0?Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     text("Taxes : ",
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontMedium,
                                        //         textColor: Colors.black),
                                        //     text(
                                        //         "₹" + widget.model.gstAmount.toString(),
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontMedium,
                                        //         textColor: Colors.black),
                                        //   ],
                                        // ):SizedBox(),
                                        // double.parse(widget.model.surgeAmount.toString())>0?Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     text("Surge Amount : ",
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontMedium,
                                        //         textColor: Colors.black),
                                        //     text(
                                        //         "₹" + widget.model.surgeAmount.toString(),
                                        //         fontSize: 10.sp,
                                        //         fontFamily: fontMedium,
                                        //         textColor: Colors.black),
                                        //   ],
                                        // ):SizedBox(),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            text("Total : ",
                                                fontSize: 10.sp,
                                                fontFamily: fontMedium,
                                                textColor: Colors.black),
                                            text("₹" + "${widget.model.amount}",
                                                fontSize: 10.sp,
                                                fontFamily: fontMedium,
                                                textColor: Colors.black),
                                          ],
                                        ),

                                        widget.model.admin_commision != null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  text(
                                                      "${getTranslated(context, "Admincommission")} : ",
                                                      fontSize: 10.sp,
                                                      fontFamily: fontMedium,
                                                      textColor: Colors.black),
                                                  text(
                                                      "₹" +
                                                          "${widget.model.admin_commision}",
                                                      fontSize: 10.sp,
                                                      fontFamily: fontMedium,
                                                      textColor: Colors.black),
                                                ],
                                              )
                                            : SizedBox(),
                                        boxHeight(10),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ),
      ),
    );
  }

  getDifference() {
    String date = widget.model.pickupDate.toString();
    DateTime temp = DateTime.parse(date);
    print(temp);
    print(date);
    if (temp.day == DateTime.now().day) {
      String time = widget.model.pickupTime.toString().split(" ")[0];
      int i = 0;
      if (widget.model.pickupTime.toString().split(" ").length > 1 &&
          widget.model.pickupTime.toString().split(" ")[1].toLowerCase() ==
              "pm") {
        i = 12;
      }
      DateTime temp = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.parse(time.split(":")[0]) + i,
          int.parse(time.split(":")[1]));
      print("check" + temp.difference(DateTime.now()).inMinutes.toString());
      print(temp);
      print(DateTime.now());
      print(1 > temp.difference(DateTime.now()).inMinutes);
      return 1 > temp.difference(DateTime.now()).inMinutes;
    } else {
      print(false);
      return false;
    }
  }
}
