import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_ecommerce_app/Providers/authProvider/authProvider.dart';
import 'package:my_ecommerce_app/app/modules/settings/screens/gallery_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Providers/BottomNavProvider.dart';
import '../../../widgets/bottomNav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String route = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void init() async {
    Provider.of<AuthProvider>(context, listen: false).userData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    Provider.of<BottomNavProvider>(context, listen: false).curIndex = 2;
    print(Provider.of<BottomNavProvider>(context, listen: false).curIndex);
  }

  Future<bool> setOnWilPop() async {
    Provider.of<BottomNavProvider>(context, listen: false).curIndex = 0;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: setOnWilPop,
      child: Consumer<AuthProvider>(builder: (context, ap, _) {
        var user = ap.user;
        return Scaffold(
          body: Stack(
            children: [
              Container(
                height: Get.height,
                width: Get.width,
              ),
              Column(
                children: [
                  Container(
                    height: kToolbarHeight * 2.2,
                    width: Get.width,
                    color: Get.theme.backgroundColor.withOpacity(0.5),
                    child: Column(
                      children: [
                        SizedBox(height: kToolbarHeight),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
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
                                  color:
                                      Get.theme.backgroundColor.withOpacity(1),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Profile',
                                      style: Get.theme.textTheme.headline5!
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: IconButton(
                                onPressed: () {
                                  Get.to(GalleryScreen());
                                },
                                icon: Icon(
                                  Icons.settings_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: Get.width,
                            color: Get.theme.backgroundColor.withOpacity(0.5),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: Get.width * 0.15,
                                  child: CachedNetworkImage(
                                    imageUrl: user.image!,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      child: Container(
                                        margin: EdgeInsets.all(5.0),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                    placeholder: (context, url) => ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.white,
                                        period: Duration(seconds: 1),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(user.image!),
                                                fit: BoxFit.cover,
                                                colorFilter: ColorFilter.mode(
                                                    Colors.red,
                                                    BlendMode.color)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.white,
                                        period: Duration(seconds: 1),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(user.image!),
                                                fit: BoxFit.cover,
                                                colorFilter: ColorFilter.mode(
                                                    Colors.red,
                                                    BlendMode.color)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  height: 10,
                                  width: Get.width * 0.6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${user.firstName! ?? ''} ${user.maidenName! ?? ' '} ${user.lastName! ?? ' '}',
                                            maxLines: 2,
                                            style: Get
                                                .theme.textTheme.headline6!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                        OutlinedButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Edit',
                                            style:
                                                Get.theme.textTheme.bodyText1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            user.phone ?? ' ',
                                            maxLines: 2,
                                            style:
                                                Get.theme.textTheme.bodyText1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      user.email ?? '',
                                      maxLines: 2,
                                      style: Get.theme.textTheme.bodyText1,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      user.company!.name ?? '',
                                      maxLines: 2,
                                      style: Get.theme.textTheme.bodyText1,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Primary Bank: ${user.bank!.iban!}' ?? '',
                                      maxLines: 2,
                                      style: Get.theme.textTheme.bodyText1,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Pin Code: ${user.address!.postalCode!}' ??
                                          '',
                                      maxLines: 2,
                                      style: Get.theme.textTheme.bodyText1,
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: DefaultBottomNav(),
        );
      }),
    );
  }
}
