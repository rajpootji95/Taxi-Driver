import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:why_taxi_driver/Auth/Login/UI/login_page.dart';
import 'package:why_taxi_driver/DrawerPages/Home/offline_page.dart';
import 'package:why_taxi_driver/Provider/UserProvider.dart';
import 'package:why_taxi_driver/Theme/style.dart';
import 'package:why_taxi_driver/utils/Demo_Localization.dart';
import 'package:why_taxi_driver/utils/PushNotificationService.dart';
import 'package:why_taxi_driver/utils/Session.dart';
import 'package:why_taxi_driver/utils/common.dart';
import 'package:why_taxi_driver/utils/constant.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'Auth/login_navigator.dart';
import 'DrawerPages/Settings/language_cubit.dart';
import 'DrawerPages/Settings/theme_cubit.dart';
import 'Locale/locale.dart';
import 'Routes/page_routes.dart';
import 'map_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  MapUtils.getMarkerPic();
  MobileAds.instance.initialize();
  String? locale = prefs.getString('locale');
  bool? isDark = prefs.getBool('theme');
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: AppTheme.primaryColor, // status bar color
  ));

  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => LanguageCubit(locale)),
    BlocProvider(create: (context) => ThemeCubit(isDark ?? false)),
  ], child: WhyTaxiDriver()));
}

class WhyTaxiDriver extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _WhyTaxiDriverState state =
        context.findAncestorStateOfType<_WhyTaxiDriverState>()!;
    state.setLocale(newLocale);
  }

  @override
  State<WhyTaxiDriver> createState() => _WhyTaxiDriverState();
}

class _WhyTaxiDriverState extends State<WhyTaxiDriver> {
  bool _isKeptOn = true;
  double _brightness = 1.0;
  Locale? _locale;

  setLocale(Locale locale) {
    if (mounted)
      setState(() {
        _locale = locale;
      });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      if (mounted)
        setState(() {
          this._locale = locale;
        });
    });
    super.didChangeDependencies();
  }

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    await App.init();
    bool keptOn = await WakelockPlus.enabled;
    if (App.localStorage.getBool("lock") != null) {
      doLock = App.localStorage.getBool("lock")!;
      WakelockPlus.toggle(enable: App.localStorage.getBool("lock")!);
    }
    if (App.localStorage.getBool("notification") != null) {
      notification = App.localStorage.getBool("notification")!;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider())
        ],
        child: BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return BlocBuilder<ThemeCubit, ThemeData>(
              builder: (context, theme) {
                return MaterialApp(
                  locale: _locale,
                  supportedLocales: [
                    Locale("en", "US"),
                    Locale("ne", "NPL"),
                  ],
                  localizationsDelegates: [
                    DemoLocalization.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  routes: {
                    '/': (BuildContext context) => OfflinePage(""),
                    'Login': (BuildContext context) => LoginPage(),
                  },
                  localeResolutionCallback: (locale, supportedLocales) {
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                              locale!.languageCode &&
                          supportedLocale.countryCode == locale.countryCode) {
                        return supportedLocale;
                      }
                    }
                    return supportedLocales.first;
                  },
                  theme: theme,
                  navigatorKey: NavigationService.navigatorKey,
                  initialRoute: "Login",
                  //  home: LoginPage(),
                  //routes: PageRoutes().routes(),
                  debugShowCheckedModeBanner: false,
                );
              },
            );
          },
        ),
      );
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}