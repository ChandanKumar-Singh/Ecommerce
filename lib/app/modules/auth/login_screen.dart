import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecommerce_app/app/routes/app_pages.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  static const String route = '/login';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Container(
        width: Get.width * 0.9,
        height: Get.height,
        color: Get.theme.primaryColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spacer(),
                SizedBox(height: Get.height * 0.3),
                Image.asset(
                  'assets/app/app_logo.png',
                  width: Get.width * 0.3,
                ),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Name'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Phone'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Email'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Password'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(value: true, onChanged: (v) {}),
                          SizedBox(width: 15),
                          Text('Receive mails and notifications'),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                Get.offAllNamed(Routes.HOME);
                              },
                              child: Text('Create account'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              'assets/auth/google.png',
                              width: Get.width * 0.1,
                            ),
                          ),
                          SizedBox(width: Get.width * 0.1),
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              'assets/auth/facebook.png',
                              width: Get.width * 0.09,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Already have a account?'),
                          TextButton(
                            child: Text('Sign In'),
                            onPressed: () {
                              _scaffoldKey.currentState!.closeEndDrawer();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Spacer(),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          height: Get.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spacer(),
                SizedBox(height: Get.height * 0.3),
                Image.asset(
                  'assets/app/app_logo.png',
                  width: Get.width / 3,
                ),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(hintText: 'username'),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'username'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(value: true, onChanged: (v) {}),
                          SizedBox(width: 15),
                          Text('Receive mails and notifications'),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                Get.offAllNamed(Routes.HOME);
                              },
                              child: Text('Sign In'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              'assets/auth/google.png',
                              width: Get.width * 0.1,
                            ),
                          ),
                          SizedBox(width: Get.width * 0.1),
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              'assets/auth/facebook.png',
                              width: Get.width * 0.09,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text('Create new account'),
                            onPressed: () {
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
