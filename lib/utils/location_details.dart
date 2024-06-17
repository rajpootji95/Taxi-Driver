import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'package:geocode/geocode.dart';

import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:why_taxi_driver/main.dart';

import 'package:why_taxi_driver/utils/ApiBaseHelper.dart';
import 'package:why_taxi_driver/utils/Session.dart';
import 'package:why_taxi_driver/utils/common.dart';
import 'package:why_taxi_driver/utils/constant.dart';

class GetLocation {
  LocationData? _currentPosition;
  BuildContext context;
  late String _address = "";
  Location location1 = Location();
  String firstLocation = "", lat = "", lng = "";
  ValueChanged onResult;
  bool status;
  GetLocation(this.context,this.onResult, {this.status = false});
  Future<void> getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location1.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location1.requestService();
      if (!_serviceEnabled) {
        print('ek');
        return;
      }
    }
    _permissionGranted = await location1.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
     /*await showDialog(context: context, barrierDismissible: false,builder: (context){
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            "Enhance Your Experience: Enable Background Location Access",
          ),
          content:  SelectableText(
            """Granting background location access is essential for the smooth operation of our app. Thank you for your understanding and cooperation.\n\nTo grant background location access:\n1.Click on 'Allow' when prompted.\n2.Select 'Allow all the time' to ensure uninterrupted service, even in the background.""",
          ),
          actions: [
            ElevatedButton(
              onPressed:
                  () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                  backgroundColor: Colors.red),
              child: Text(
                "Cancel",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 12.0, color: Colors.white),
              ),
            ),
            SizedBox(width: 10,),
            ElevatedButton(
              onPressed: ()async{
                Navigator.pop(context);
                _permissionGranted = await location1.requestPermission();
                if (_permissionGranted != PermissionStatus.granted) {
                  print('no');
                  return;
                }
              },
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                  backgroundColor: Colors.green),
              child: Text(
                "Continue",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 12.0, color: Colors.white),
              ),
            ),
          ],
        );
      });*/
      _permissionGranted = await location1.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('no');
        return;
      }
    }
  /*  bool enableBackground = await location1.isBackgroundModeEnabled();
    if(!enableBackground){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            "Background Permission Denied: Impact on App Experience",
          ),
          content: SelectableText(
            """Without background location access, our app's features may be limited, compromising your experience. Granting permission ensures seamless functionality and personalized services tailored to your needs.\n\nTo grant background location access:\n1.Open your device's settings.\n2.Navigate to 'App Permissions' or 'Privacy.'
\n3.Find our app and enable 'Always allow Location Access.'""",
          ),
          actions: [
            ElevatedButton(
              onPressed: ()async{
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                  backgroundColor: Colors.green),
              child: Text(
                "Continue",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 12.0, color: Colors.white),
              ),
            ),
          ],
        );
      });
    }*/
    location1.changeSettings(
      interval: 5000,
    );
   // location1.enableBackgroundMode(enable:true);
    location1.changeNotificationOptions(
      channelName: 'background_channel',
      title: "Location Access",
      description: "This app fetching location in background",
    );
    location1.onLocationChanged.listen((LocationData currentLocation) {
     // print("${currentLocation.latitude} : ${currentLocation.longitude}");
      _currentPosition = currentLocation;
     // print(currentLocation.latitude);
      lat = _currentPosition!.latitude.toString();
      lng = _currentPosition!.longitude.toString();

      updateLocation();
      _getAddress(_currentPosition!.latitude, _currentPosition!.longitude)
          .then((value) {
        _address = "${value.first.streetAddress}";
        firstLocation = value.first.city.toString();
       // print(_address);

        if (latitude != _currentPosition!.latitude) {
          latitudeTemp = _currentPosition!.latitude!;
          longitudeTemp = _currentPosition!.longitude!;
          print("ok");
          onResult(value);
        } else {
          if (status) {
            onResult(value);
          }
        }
        if (latitude == 0) {
          latitudeTemp = _currentPosition!.latitude!;
          longitudeTemp = _currentPosition!.longitude!;
        }
      });
    });
  }

  ApiBaseHelper apiBase = new ApiBaseHelper();
  bool isNetwork = false;
  updateLocation() async {
    await App.init();
    isNetwork = await isNetworkAvailable();
    if (isNetwork) {
      try {
        Map data;
        data = {
          "user_id": curUserId,
          "lat": lat.toString(),
          "lang": lng.toString()
        };
        var response = await post(Uri.parse(baseUrl + "update_lat_lang_driver"),
            body: data);
      } on TimeoutException catch (_) {}
    } else {}
  }

  Future<List<Address>> _getAddress(double? lat, double? lang) async {
    Address add =
        await GeoCode().reverseGeocoding(latitude: lat!, longitude: lang!);
    return [add];
  }
}
