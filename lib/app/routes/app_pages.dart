import 'package:get/get.dart';
import 'package:my_ecommerce_app/Providers/productProvider/productProvider.dart';
import 'package:my_ecommerce_app/app/modules/Basket/Basket.dart';
import 'package:my_ecommerce_app/app/modules/CheckOut/CheckOut.dart';
import 'package:my_ecommerce_app/app/modules/CheckOut/addPayment.dart';
import 'package:my_ecommerce_app/app/modules/Notification/notification.dart';
import 'package:my_ecommerce_app/app/modules/Profile/profile.dart';
import 'package:my_ecommerce_app/app/modules/auth/login_screen.dart';
import 'package:my_ecommerce_app/app/modules/catlog/catlog.dart';

import 'package:my_ecommerce_app/app/modules/home/bindings/home_binding.dart';
import 'package:my_ecommerce_app/app/modules/home/views/home_view.dart';
import 'package:my_ecommerce_app/app/modules/productDetails/productDeatils.dart';
import 'package:my_ecommerce_app/app/modules/splashScreen/splash_screen.dart';
import 'package:my_ecommerce_app/app/modules/whishList/wishlist.dart';

import '../modules/CheckOut/orederPlaced.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;
  static const HOME = Routes.HOME;
  static const LOGIN = Routes.LOGIN;
  static const CART = Routes.CART;
  static const CATLOG = Routes.CATLOG;
  static const NOTIFICATION = Routes.NOTIFICATION;
  static const DETAILS = Routes.DETAILS;
  static const WISHLIST = Routes.WISHLIST;
  static const CHECKOUT = Routes.CHECKOUT;
  static const PAYMENT = Routes.PAYMENT;
  static const ORDERCONFIRMATION = Routes.ORDERCONFIRMATION;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ), // binding: HomeBinding(),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginScreen(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CATLOG,
      page: () => Catlog(
        categogy: Get.arguments as String,
      ),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => Cart(
          // categogy: Get.arguments as String,
          ),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationScreen(
          // categogy: Get.arguments as String,
          ),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileScreen(
          // categogy: Get.arguments as String,
          ),
    ),
    GetPage(
      name: _Paths.DETAILS,
      page: () => ProductDetails(
        product: Get.arguments as ProductModel,
      ),
    ),
    // binding: HomeBinding(),),
    GetPage(
      name: _Paths.WISHLIST,
      page: () => WishList(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => Checkout(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => PaymentPage(),
      // binding: HomeBinding(),
    ),
      GetPage(
      name: _Paths.ORDERCONFIRMATION,
      page: () => OrderConfirmation(),
      // binding: HomeBinding(),
    ),
  ];
}
