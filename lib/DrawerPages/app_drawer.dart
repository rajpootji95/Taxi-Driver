import 'dart:async';
import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:why_taxi_driver/Assets/assets.dart';
import 'package:why_taxi_driver/Auth/Login/UI/login_page.dart';
import 'package:why_taxi_driver/DrawerPages/ContactUs/contact_us_page.dart';
import 'package:why_taxi_driver/DrawerPages/Home/offline_page.dart';
import 'package:why_taxi_driver/DrawerPages/Profile/reviews.dart';
import 'package:why_taxi_driver/DrawerPages/ReferEarn/refer_earn.dart';
import 'package:why_taxi_driver/DrawerPages/Rides/intercity_rides.dart';
import 'package:why_taxi_driver/DrawerPages/Rides/my_rides_page.dart';
import 'package:why_taxi_driver/DrawerPages/Rides/rental_rides.dart';
import 'package:why_taxi_driver/DrawerPages/Settings/settings_page.dart';
import 'package:why_taxi_driver/DrawerPages/Wallet/wallet_page.dart';
import 'package:why_taxi_driver/DrawerPages/address.dart';
import 'package:why_taxi_driver/DrawerPages/faq_page.dart';
import 'package:why_taxi_driver/DrawerPages/joining_bonus.dart';
import 'package:why_taxi_driver/DrawerPages/new_aaccount.dart';

import 'package:why_taxi_driver/Theme/style.dart';

import 'package:why_taxi_driver/utils/Session.dart';
import 'package:why_taxi_driver/utils/colors.dart';
import 'package:why_taxi_driver/utils/common.dart';
import 'package:why_taxi_driver/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Profile/my_profile.dart';

import 'package:http/http.dart' as http;

import 'accounts.dart';

class AppDrawer extends StatefulWidget {
  final bool fromHome;
  ValueChanged onResult;
  AppDrawer({this.fromHome = true, required this.onResult});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  // BannerAd? _anchoredBanner;
  bool _loadingAnchoredBanner = false;

  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    // final BannerAd banner = BannerAd(
    //   size: size,
    //   request: request,
    //   adUnitId: Platform.isAndroid
    //       ? 'ca-app-pub-3940256099942544/6300978111'
    //       : 'ca-app-pub-3940256099942544/2934735716',
    //   listener: BannerAdListener(
    //     onAdLoaded: (Ad ad) {
    //       print('$BannerAd loaded.');
    //       setState(() {
    //         _anchoredBanner = ad as BannerAd?;
    //       });
    //     },
    //     onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //       print('$BannerAd failedToLoad: $error');
    //       ad.dispose();
    //     },
    //     onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
    //     onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
    //   ),
    // );
    // return banner.load();
  }

  String userNumber = "";
  getNumber() async {
    try {
      Map params = {
        "user_id": curUserId.toString(),
      };
      var res = await http.get(
        Uri.parse(baseUrl + "/get_setting"),
      );
      Map response = jsonDecode(res.body);
      if (response['status']) {
        var data = response["data"];
        print(data);
        setState(() {
          userNumber = data['driver_number'];
          contactEmail = data['contact_email'];
          contactNo = data['contact_number'];
        });
      } else {
        UI.setSnackBar(response['message'], context);
      }
    } on TimeoutException catch (_) {
      UI.setSnackBar("Something Went Wrong", context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNumber();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Builder(builder: (BuildContext context) {
      if (!_loadingAnchoredBanner) {
        _loadingAnchoredBanner = true;
        _createAnchoredBanner(context);
      }
      return Drawer(
        child: SafeArea(
          child: FadedSlideAnimation(
            child: ListView(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyProfilePage()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 12, right: 12, top: 9),
                    color: theme.scaffoldBackgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 16, 8, 6),
                          child: Row(
                            children: [
                              Container(
                                height: 72,
                                width: 72,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    image,
                                    height: 72,
                                    width: 72,
                                    fit: BoxFit.fill,
                                    colorBlendMode: profileStatus == "0"
                                        ? BlendMode.hardLight
                                        : BlendMode.color,
                                    color: profileStatus == "0"
                                        ? Colors.white.withOpacity(0.4)
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: getWidth(150),
                                    child: Text(name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: theme.textTheme.headline5),
                                  ),
                                  SizedBox(height: 6),
                                  Text(mobile, style: theme.textTheme.caption),
                                  SizedBox(height: 4),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppTheme.ratingsColor,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(rating,style: TextStyle(color: MyColorName.colorBg2,),),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.star,
                                          color: MyColorName.colorBg2,
                                          size: 14,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        /* IconButton(
                            icon: Icon(Icons.close),
                            color: theme.primaryColor,
                            iconSize: 28,
                            onPressed: () => Navigator.pop(context)),
                        SizedBox(
                          height: 8,
                        ),*/
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 24,
                // ),
                // if (_anchoredBanner != null)
                //   Container(
                //     width: _anchoredBanner!.size.width.toDouble(),
                //     height: _anchoredBanner!.size.height.toDouble(),
                //     child: AdWidget(ad: _anchoredBanner!),
                //   ),
                buildListTile(
                    context, Icons.home, getTranslated(context, "HOME")!, () {
                  Navigator.pop(context);
                  /*Navigator.popUntil(
                    context,
                    ModalRoute.withName('/'),
                  );*/
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OfflinePage("")),
                  );*/
                  /*if (widget.fromHome)
                    Navigator.pushReplacementNamed(
                        context, PageRoutes.offlinePage);
                  else
                    Navigator.pushReplacementNamed(
                        context, PageRoutes.offlinePage);*/
                }),
                buildListTile(context, Icons.person,
                    getTranslated(context, "MY_PROFILE")!, () async {
                  //Navigator.pop(context);
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyProfilePage()),
                  );
                  if (result != null) {
                    widget.onResult(result);
                  }
                  Navigator.pop(context);
                }),
              /*  ListTile(
                  title: Text(
                    getTranslated(context, "MY_ADDRESS")!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: Icon(Icons.location_on_outlined,
                      color: Color(0xffF36B21)),
                  *//*   trailing: Text("₹500",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),*//*
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddressScreen()),
                    );
                    *//* Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReferEarn()),
                    );*//*
                  },
                ),*/
               /* ListTile(
                  title: Text(
                    getTranslated(context, "Joining")!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: Icon(Icons.star, color: Color(0xffF36B21)),

                  onTap: () async {
                    //Navigator.pop(context);
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JoiningBonus()),
                    );
                    if (result != null) {
                      widget.onResult(result);
                    }
                    Navigator.pop(context);
                  },
                ),*/
                ListTile(
                  title: Text(
                    getTranslated(context, "ACCOUNTS")!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: Icon(Icons.payment, color: AppTheme.primaryColor),
                  /*   trailing: Text("₹500",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),*/
                  onTap: () async {
                    //Navigator.pop(context);
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountPage()),
                    );
                    if (result != null) {
                      widget.onResult(result);
                    }
                    Navigator.pop(context);
                    /* Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReferEarn()),
                    );*/
                  },
                ),
                /* buildListTile(context, Icons.star,
                    getTranslated(context,Strings.Joining)!, () {
                      Navigator.popAndPushNamed(context, PageRoutes.myProfilePage);
                    }),*/
                buildListTile(context, Icons.drive_eta,
                    getTranslated(context, "MY_RIDES")!, () async {
                  // Navigator.pop(context);
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyRidesPage()),
                  );
                  if (result != null) {
                    widget.onResult(result);
                  }
                  Navigator.pop(context);
                  //Navigator.popAndPushNamed(context, PageRoutes.myRidesPage);
                }),
                /*buildListTile(context, Icons.history, "Intercity", () async {
                  //    Navigator.pop(context);
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IntercityRides(
                              selected: false,
                            )),
                  );
                  if (result != null) {
                    widget.onResult(result);
                  }
                  Navigator.pop(context);
                }),*/
                /*ListTile(
                  title: Text(
                    getTranslated(context, "RENTAL_RIDES")!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: Icon(Icons.location_on_outlined,
                      color: Color(0xffF36B21)),

                  onTap: () async {
                    //  Navigator.pop(context);
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RentalRides()),
                    );
                    if (result != null) {
                      widget.onResult(result);
                    }
                    Navigator.pop(context);

                  },
                ),*/
                buildListTile(
                    context, Icons.star, getTranslated(context, "MY_RATINGS")!,
                    () async {
                  // Navigator.pop(context);
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewsPage()),
                  );
                  if (result != null) {
                    widget.onResult(result);
                  }
                  Navigator.pop(context);
                  /*Navigator.popAndPushNamed(context, PageRoutes.reviewsPage);*/
                }),
                buildListTile(context, Icons.account_balance_wallet,
                    getTranslated(context, "WALLET")!, () async {
                  // Navigator.pop(context);
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WalletPage()),
                  );
                  if (result != null) {
                    widget.onResult(result);
                  }
                  Navigator.pop(context);
                }),
               /* ListTile(
                  title: Text(
                    getTranslated(context, "ReferEarn")??'',
                    maxLines: 1,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(Icons.qr_code, color: Color(0xffF36B21)),
                  onTap: () async {
                    //Navigator.pop(context);
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReferEarn()),
                    );
                    if (result != null) {
                      widget.onResult(result);
                    }
                    Navigator.pop(context);
                  },
                ),*/
                // buildListTile(context, Icons.local_offer,
                //     getTranslated(context,Strings.PROMO_CODE)!, () {
                //       if (widget.fromHome)
                //         Navigator.popAndPushNamed(context, PageRoutes.promoCode);
                //       else
                //         Navigator.pushReplacementNamed(
                //             context, PageRoutes.promoCode);
                //     }),
               /* buildListTile(context, Icons.settings,
                    getTranslated(context, "SETTINGS")!, () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );

                }),*/
                buildListTile(context, Icons.call,
                    getTranslated(context, "EmergencyCall")!, () {
                  launch("tel://${userNumber}");
                }),
                buildListTile(
                    context, Icons.help, getTranslated(context, "FAQS")!, () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FaqPage()),
                  );

                }),
                buildListTile(
                    context, Icons.mail, getTranslated(context, "CONTACT_US")!,
                    () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUsPage()),
                  );

                }),
                buildListTile(
                    context, Icons.logout, getTranslated(context, "Logout")!,
                    () {
                  showDialog(
                      context: context,
                      // barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Log Out"
                              // getTranslated(context, "Logout")!
                              ),
                          content: Text("Do you want to Logout ?"
                              // getTranslated(context, "Doyouwanttologout")!
                              ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text(getTranslated(context, "No")!),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    MyColorName.colorMainButton),
                              ),
                              /*  textColor: Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent)),*/
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                                child: Text(getTranslated(context, "Yes")!),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      MyColorName.primaryLite),
                                ),
                                /* shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.transparent)),
                                textColor: Theme.of(context).colorScheme.primary,*/
                                onPressed: () async {
                                  await App.init();


                                  App.localStorage.clear();
                                  Common.logoutApi();
                                  //Common().toast("Logout");
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                      (route) => false);
                                }),
                          ],
                        );
                      });
                }),
                // Container(
                //   padding: EdgeInsets.only(left: 12, right: 12, top: 20),
                //   color: theme.scaffoldBackgroundColor,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Padding(
                //         padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                //         child: Row(
                //           children: [
                //             ClipRRect(
                //               borderRadius: BorderRadius.circular(12),
                //               child: Image.asset(
                //                 Assets.Driver,
                //                 height: 72,
                //                 width: 72,
                //               ),
                //             ),
                //             SizedBox(width: 16),
                //             Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text('Sam Smith',
                //                     style: theme.textTheme.headline5),
                //                 SizedBox(height: 6),
                //                 Text('+91 8888888888',
                //                     style: theme.textTheme.caption),
                //                 SizedBox(height: 4),
                //                 Container(
                //                   padding: EdgeInsets.symmetric(
                //                       horizontal: 6, vertical: 2),
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(30),
                //                     color: AppTheme.ratingsColor,
                //                   ),
                //                   child: Row(
                //                     children: [
                //                       Text('4.2'),
                //                       SizedBox(width: 4),
                //                       Icon(
                //                         Icons.star,
                //                         color: AppTheme.starColor,
                //                         size: 14,
                //                       )
                //                     ],
                //                   ),
                //                 ),
                //               ],
                //             )
                //           ],
                //         ),
                //       ),
                //       IconButton(
                //           icon: Icon(Icons.close),
                //           color: theme.primaryColor,
                //           iconSize: 28,
                //           onPressed: () => Navigator.pop(context)),
                //       SizedBox(
                //         height: 8,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            beginOffset: Offset(0, 0.3),
            endOffset: Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
          ),
        ),
      );
    });
  }

  ListTile buildListTile(BuildContext context, IconData icon, String title,
      [Function? onTap]) {
    var theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.primaryColor, size: 24),
      title: Text(
        title,
        style: theme.textTheme.headline5!
            .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      onTap: onTap as void Function()?,
    );
  }
}
