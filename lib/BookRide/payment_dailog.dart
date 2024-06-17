
import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:why_taxi_driver/Components/row_item.dart';
import 'package:why_taxi_driver/Model/my_ride_model.dart';
import 'package:why_taxi_driver/utils/Session.dart';
import 'package:why_taxi_driver/utils/constant.dart';
import 'package:why_taxi_driver/utils/widget.dart';
import 'package:sizer/sizer.dart';

class PaymentDialog extends StatefulWidget {
  MyRideModel model;
  final bool from;
  PaymentDialog(this.model,{this.from = false});
  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  double rating = 0.0;
  TextEditingController desCon = new TextEditingController();
  String paymentType = "Cash";
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      insetPadding:const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                                "$imagePath${widget.model.userImage}",
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
              Divider(),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16))),
                child: Row(
                  children: [
                    RowItem(
                        'Extra Payment',
                        '\u{20B9}${widget.model.add_on_charge}',
                        Icons.account_balance_wallet),
                    Spacer(),
                    RowItem('Extra Time', ' ${widget.model.add_on_time}/min.',
                        Icons.timer),
                    Spacer(),
                    RowItem('Extra KM', '${widget.model.add_on_distance}/km.',
                        Icons.drive_eta),
                  ],
                ),
              ),
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
             /* widget.model.admin_commision != null
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
                  : SizedBox(),*/
              boxHeight(10),
            ],
          ),
        ),
      ),
    );
  }

}
