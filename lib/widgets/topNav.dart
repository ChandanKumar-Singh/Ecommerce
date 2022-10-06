import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NavHeader extends StatelessWidget {
  const NavHeader({
    Key? key,
    required this.title,
    required this.route,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String route;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Get.theme.backgroundColor.withOpacity(1),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Container(
            height: 50,
            width: Get.width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.theme.backgroundColor.withOpacity(1),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: Get.theme.textTheme.headline5!
                      .copyWith(fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: IconButton(
            onPressed: () {
              Get.toNamed(route);
            },
            icon: Icon(
              icon,
              color: Get.theme.backgroundColor.withOpacity(1),
            ),
          ),
        ),
      ],
    );
  }
}
