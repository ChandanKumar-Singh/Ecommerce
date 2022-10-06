import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecommerce_app/app/modules/Notification/notification.dart';

import '../app/modules/Basket/Basket.dart';
import '../app/modules/Profile/profile.dart';

class DefaultBottomNav extends StatefulWidget {
  const DefaultBottomNav({
    Key? key,
  }) : super(key: key);

  @override
  State<DefaultBottomNav> createState() => _DefaultBottomNavState();
}

class _DefaultBottomNavState extends State<DefaultBottomNav> {
  @override
  Widget build(BuildContext context) {
    var color0 = Colors.black;
    var color1 = Colors.black;
    var color2 = Colors.black;
    var color3 = Colors.black;
    // return Consumer<BottomNavProvider>(builder: (context, bnp, _) {
    //   return BottomNavigationBar(
    //     currentIndex: bnp.curIndex,
    //     onTap: (i) {
    //       setState(() {
    //         bnp.curIndex = i;
    //       });
    //       if (bnp.curIndex == 0) {
    //         Get.offAllNamed('/home');
    //       } else if (bnp.curIndex == 1) {
    //         Get.toNamed(Cart.route);
    //       } else {
    //         Get.toNamed('/profile');
    //       }
    //     },
    //     items: [
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.home_outlined), label: 'Home'),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.person_outline_outlined), label: 'Profile'),
    //     ],
    //   );
    // });
    return BottomAppBar(
      // color: Get.theme.backgroundColor,
      child: Container(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Get.offAllNamed('/home');
              },
              icon: Icon(
                Icons.home_outlined,
                color: color0,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(Cart.route);
              },
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: color1,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(NotificationScreen.route);
              },
              icon: Icon(
                Icons.notifications_none_outlined,
                color: color1,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(ProfileScreen.route);
              },
              icon: Icon(
                Icons.person_outline_outlined,
                color: color2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
