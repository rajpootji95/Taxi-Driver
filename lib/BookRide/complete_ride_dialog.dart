import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:why_taxi_driver/Components/custom_button.dart';
import 'package:why_taxi_driver/Components/entry_field.dart';
import 'package:why_taxi_driver/DrawerPages/Home/offline_page.dart';
import 'package:why_taxi_driver/Model/intercity_model.dart';
import 'package:why_taxi_driver/Model/my_ride_model.dart';
import 'package:why_taxi_driver/Theme/style.dart';
import 'package:why_taxi_driver/utils/ApiBaseHelper.dart';
import 'package:why_taxi_driver/utils/Session.dart';
import 'package:why_taxi_driver/utils/common.dart';
import 'package:why_taxi_driver/utils/constant.dart';

class CompleteRideDialog extends StatefulWidget {
  MyRideModel model;

  CompleteRideDialog(this.model);
  @override
  _CompleteRideDialogState createState() => _CompleteRideDialogState();
}

class _CompleteRideDialogState extends State<CompleteRideDialog> {
  double rating = 0.0;

  TextEditingController desCon = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
         // Navigator.pop(context);
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => SearchLocationPage()),
          //         (route) => false);
          return Future.value();
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.pop(context);
                      //  Navigator.pop(context);
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => SearchLocationPage()),
                        //         (route) => false);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  // imagePath +
                                  widget.model.userImage.toString(),
                                  height: 72,
                                  width: 72,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${widget.model.username}',
                              style: theme.textTheme.headline6!
                                  .copyWith(fontSize: 18, letterSpacing: 1.2),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${widget.model.taxiType}',
                              style: theme.textTheme.caption!
                                  .copyWith(fontSize: 12),
                            ),
                            Text(
                              '${widget.model.carNo}',
                              style: theme.textTheme.bodyText1!
                                  .copyWith(fontSize: 13.5),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated(context, 'RIDE_FARE')!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 18),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '\u{20B9} ${widget.model.amount}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                            SizedBox(height: 24),
                            Text(
                              getTranslated(context, 'PAYMENT_VIA')!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 18),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  color: theme.primaryColor,
                                  size: 20,
                                ),
                                SizedBox(width: 8),

                                Expanded(
                                  child: Text(
                                    '${widget.model.transaction}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.0),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text(
                    getTranslated(context, 'RIDE_INFO')!,
                    style: theme.textTheme.headline6!
                        .copyWith(color: theme.hintColor, fontSize: 16.5),
                  ),
                  trailing: Text('${widget.model.km} km',
                      style: theme.textTheme.headline6),
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(
                    Icons.location_on,
                    color: theme.primaryColor,
                  ),
                  title: Text(
                    '${widget.model.pickupAddress}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(
                    Icons.navigation,
                    color: theme.primaryColor,
                  ),
                  title: Text(
                    '${widget.model.dropAddress}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Divider(),
                // SizedBox(
                //   height: 20,
                // ),
                // Center(
                //   child: Text(getTranslated(context, 'RATE_YOUR_RIDE')!,
                //       style: theme.textTheme.headline6!
                //           .copyWith(color: theme.hintColor)),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // Center(
                //   child: RatingBar(
                //     initialRating: rating,
                //     direction: Axis.horizontal,
                //     allowHalfRating: true,
                //     itemCount: 5,
                //     itemSize: 36,
                //     ratingWidget: RatingWidget(
                //       full: Icon(
                //         Icons.star,
                //         color: AppTheme.primaryColor,
                //       ),
                //       half: Icon(
                //         Icons.star_half_rounded,
                //         color: AppTheme.primaryColor,
                //       ),
                //       empty: Icon(
                //         Icons.star_border_rounded,
                //         color: AppTheme.primaryColor,
                //       ),
                //     ),
                //     itemPadding: EdgeInsets.zero,
                //     onRatingUpdate: (rating1) {
                //       print(rating1);
                //       setState(() {
                //         rating = rating1;
                //       });
                //     },
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // EntryField(
                //   controller: desCon,
                //   hint: getTranslated(context, 'ADD_COMMENT'),
                // ),
                SizedBox(
                  height: 20,
                ),
                !status
                    ? CustomButton(
                        onTap: () {
                          Navigator.pop(context);
                         /* Navigator.popUntil(
                            context,
                            ModalRoute.withName('/'),
                          );*/
                       /*   Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OfflinePage('')),
                              (route) => false);*/
                          // Navigator.pop(context);
                          setState(() {
                            status = true;
                          });
                          // rateOrder(
                          //     widget.model.driverId, widget.model.bookingId);
                        },
                        text: getTranslated(context, 'SUBMIT'),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool status = false;
  rateOrder(driverId, bookingId) async {
    await App.init();
    Map param = {
      "driver_id": driverId,
      "comments": desCon.text == "" ? "No Comments" : desCon.text,
      "booking_id": bookingId,
      "rating": rating.toString(),
      "user_id": curUserId,
    };
    Map response = await apiBase.postAPICall(
        Uri.parse(baseUrl1 + "payment/AddReviews"), param);
    setState(() {
      status = false;
    });
    UI.setSnackBar(response['message'], context);
    if (response['status']) {
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => SearchLocationPage()),
      //         (route) => false);
    }
  }
}

class RateRideDialog1 extends StatefulWidget {
  IntercityRideModel model;

  RateRideDialog1(this.model);
  @override
  _RateRideDialog1State createState() => _RateRideDialog1State();
}

class _RateRideDialog1State extends State<RateRideDialog1> {
  double rating = 0.0;
  TextEditingController desCon = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      child:  FadedSlideAnimation(
            child:
        SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imagePath +
                                      widget.model.driverImage.toString(),
                                  height: 72,
                                  width: 72,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${widget.model.driverName}',
                              style: theme.textTheme.headline6!
                                  .copyWith(fontSize: 18, letterSpacing: 1.2),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${widget.model.taxiType}',
                              style: theme.textTheme.caption!
                                  .copyWith(fontSize: 12),
                            ),
                            Text(
                              '${widget.model.car_no}',
                              style: theme.textTheme.bodyText1!
                                  .copyWith(fontSize: 13.5),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated(context, 'RIDE_FARE')!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 18),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '\u{20B9} ${widget.model.amount}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                            SizedBox(height: 24),
                            Text(
                              getTranslated(context, 'PAYMENT_VIA')!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 18),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  color: theme.primaryColor,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text('${widget.model.transaction}')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text(
                    getTranslated(context, 'RIDE_INFO')!,
                    style: theme.textTheme.headline6!
                        .copyWith(color: theme.hintColor, fontSize: 16.5),
                  ),
                  trailing: Text('${widget.model.km} km',
                      style: theme.textTheme.headline6),
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(
                    Icons.location_on,
                    color: theme.primaryColor,
                  ),
                  title: Text(
                    '${widget.model.pickupAddress}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(
                    Icons.navigation,
                    color: theme.primaryColor,
                  ),
                  title: Text(
                    '${widget.model.dropAddress}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(getTranslated(context, 'RATE_YOUR_RIDE')!,
                      style: theme.textTheme.headline6!
                          .copyWith(color: theme.hintColor)),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: RatingBar(
                    initialRating: rating,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 36,
                    ratingWidget: RatingWidget(
                      full: Icon(
                        Icons.star,
                        color: AppTheme.primaryColor,
                      ),
                      half: Icon(
                        Icons.star_half_rounded,
                        color: AppTheme.primaryColor,
                      ),
                      empty: Icon(
                        Icons.star_border_rounded,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    itemPadding: EdgeInsets.zero,
                    onRatingUpdate: (rating1) {
                      print(rating1);
                      setState(() {
                        rating = rating1;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                EntryField(
                  controller: desCon,
                  hint: getTranslated(context, 'ADD_COMMENT'),
                ),
                SizedBox(
                  height: 20,
                ),
                !status
                    ? CustomButton(
                        onTap: () {
                          setState(() {
                            status = true;
                          });
                          rateOrder(
                              widget.model.driverId, widget.model.bookingId);
                        },
                        text: getTranslated(context, 'SUBMIT'),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  bool status = false;
  rateOrder(driverId, bookingId) async {
    await App.init();
    Map param = {
      "driver_id": driverId,
      "comments": desCon.text == "" ? "No Comments" : desCon.text,
      "booking_id": bookingId,
      "rating": rating.toString(),
      "user_id": curUserId,
    };
    Map response = await apiBase.postAPICall(
        Uri.parse(baseUrl1 + "payment/AddReviews"), param);
    setState(() {
      status = false;
    });
    UI.setSnackBar(response['message'], context);
    if (response['status']) {
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => SearchLocationPage()),
      //         (route) => false);
    }
  }
}
