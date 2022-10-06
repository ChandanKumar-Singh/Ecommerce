import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_ecommerce_app/Providers/BottomNavProvider.dart';
import 'package:provider/provider.dart';

import '../../../widgets/bottomNav.dart';
import '../../../widgets/topNav.dart';
import '../catlog/catlog.dart';
import '../whishList/wishlist.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  static const String route = '/notification';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight),
            NavHeader(
                title: 'Notification',
                route: WishList.route,
                icon: Icons.favorite_outlined),


          ],
        ),
      ),
      bottomNavigationBar: DefaultBottomNav(),
    );
  }
}
