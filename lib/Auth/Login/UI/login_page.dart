import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'package:why_taxi_driver/DrawerPages/Home/offline_page.dart';
import 'package:why_taxi_driver/DrawerPages/Profile/my_profile.dart';
import 'package:why_taxi_driver/utils/PushNotificationService.dart';
import 'package:why_taxi_driver/utils/common.dart';
import 'package:why_taxi_driver/utils/constant.dart';
import 'package:why_taxi_driver/utils/location_details.dart';
import '../../login_navigator.dart';
import 'login_interactor.dart';
import 'login_ui.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginInteractor {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /* PushNotificationService notificationService = new PushNotificationService(context: context,onResult: (result){

    });
    notificationService.initialise();*/
    changePage();
  }

  changePage() async {
    await App.init();

    if (App.localStorage.getString("userId") != null) {
      curUserId = App.localStorage.getString("userId").toString();

      Navigator.popAndPushNamed(context, "/");
      /*Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OfflinePage("")),
          (route) => false);*/
      return;
    }
    if (App.localStorage.getString("userProfileId") != null) {
      curUserId = App.localStorage.getString("userProfileId").toString();


      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyProfilePage()),
          (route) => false);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginUI(this);
  }

  @override
  void loginWithMobile(String isoCode, String mobileNumber) {
    Navigator.pushNamed(context, LoginRoutes.registration,
        arguments: isoCode + mobileNumber);
  }
}
