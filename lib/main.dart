import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_ecommerce_app/Providers/Category.dart';
import 'package:my_ecommerce_app/Providers/authProvider/authProvider.dart';

import 'package:my_ecommerce_app/Providers/wishlist/wishlistProvider.dart';
import 'package:my_ecommerce_app/theme/Theme.dart';
import 'package:provider/provider.dart';

import 'Providers/BottomNavProvider.dart';
import 'Providers/cart/cartProvider.dart';
import 'Providers/checkout/checkoutProvider.dart';
import 'Providers/productProvider/productProvider.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:firedart/firedart.dart';
import 'package:desktop_window/desktop_window.dart';

Future testWindowFunctions() async {
  Size size = await DesktopWindow.getWindowSize();
  print(size);
  await DesktopWindow.setWindowSize(Size(450, 850));

  // await DesktopWindow.setMinWindowSize(Size(400,400));
  // await DesktopWindow.setMaxWindowSize(Size(800,800));
  //
  // await DesktopWindow.resetMaxWindowSize();
  // await DesktopWindow.toggleFullScreen();
  // bool isFullScreen = await DesktopWindow.getFullScreen();
  // await DesktopWindow.setFullScreen(true);
  await DesktopWindow.setFullScreen(false);
}

const String apiKey = "AIzaSyAuphJdsVHhjiDb4n-Q4L3ngQJE8KKmhW8";
const String authDomain = "my-cashbook-b853c.firebaseapp.com";
const String databaseURL =
    "https://my-cashbook-b853c-default-rtdb.firebaseio.com";
const String projectId = "my-cashbook-b853c";
const String storageBucket = "my-cashbook-b853c.appspot.com";
const String messagingSenderId = "259945473732";
const String appId = "1:259945473732:web:33c29726e5c00cfdb84b91";
const String measurementId = "G-NZX959E5TZ";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isWindows) {
  //   await testWindowFunctions();
  // }

  // const firebaseConfig = {
  //   apiKey: "AIzaSyAuphJdsVHhjiDb4n-Q4L3ngQJE8KKmhW8",
  //   authDomain: "my-cashbook-b853c.firebaseapp.com",
  //   databaseURL: "https://my-cashbook-b853c-default-rtdb.firebaseio.com",
  //   projectId: "my-cashbook-b853c",
  //   storageBucket: "my-cashbook-b853c.appspot.com",
  //   messagingSenderId: "259945473732",
  //   appId: "1:259945473732:web:33c29726e5c00cfdb84b91",
  //   measurementId: "G-NZX959E5TZ"
  // };
  if (Platform.isWindows) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId),
    );
    Firestore.initialize(projectId);
  }
  if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp();
  }

  runApp(
    MyEcommerceApp(),
  );
}

class MyEcommerceApp extends StatefulWidget {
  const MyEcommerceApp({Key? key}) : super(key: key);

  @override
  State<MyEcommerceApp> createState() => _MyEcommerceAppState();
}

class _MyEcommerceAppState extends State<MyEcommerceApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => BottomNavProvider()),
          ChangeNotifierProvider(create: (context) => CategoryProvider()),
          ChangeNotifierProvider(create: (context) => ProductProvider()),
          ChangeNotifierProvider(create: (context) => WishlistProvider()),
          ChangeNotifierProvider(create: (context) => CartProvider()),
          ChangeNotifierProvider(create: (context) => CheckoutProvider()),
        ],
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            theme: lightTheme,
            initialRoute: AppPages.HOME,
            getPages: AppPages.routes,
          );
        });
  }
}
