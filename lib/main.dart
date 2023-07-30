import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_sp2/app/my_app.dart';
import 'package:food_ordering_sp2/app/my_app_controller.dart';
import 'package:food_ordering_sp2/core/data/repositories/shared_prefreance_repository.dart';
import 'package:food_ordering_sp2/core/services/cart_service.dart';
import 'package:food_ordering_sp2/core/services/connectivity_service.dart';
import 'package:food_ordering_sp2/core/services/location_service.dart';
import 'package:food_ordering_sp2/firebase_options.dart';
import 'package:food_ordering_sp2/ui/views/splash_screen/splash_screen_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(
    () async {
      var sharedPref = await SharedPreferences.getInstance();
      return sharedPref;
    },
  );

  Get.put(SharedPrefranceRepository());
  Get.put(CartService());
  Get.put(LocationService());
  Get.put(ConnectivityService());
  Get.put(MyAppController());
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final fcmToken = await FirebaseMessaging.instance.getToken();
    // call api here
    print(fcmToken);

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // call api here

      // TODO: If necessary send token to application server.

      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      // Error getting token.
    });

    if (GetPlatform.isIOS) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  } catch (e) {
    print(e);
  }

  runApp(MyApp());
}
