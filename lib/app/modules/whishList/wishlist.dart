import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_ecommerce_app/app/modules/Basket/Basket.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Providers/cart/cartProvider.dart';
import '../../../Providers/wishlist/wishlistProvider.dart';
import '../../../widgets/bottomNav.dart';
import '../productDetails/productDeatils.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);
  static const String route = '/whishlist';

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  int quantity = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<WishlistProvider>(context, listen: false)
        .getWishlist()
        .asBroadcastStream()
        .listen((event) {});
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(builder: (context, wp, _) {
      print(wp.loading);
      return Scaffold(
        body: Column(
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
                          'Wishlist',
                          style: Get.theme.textTheme.headline5!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
            Builder(builder: (context) {
              if (wp.wishlists.isEmpty) {
                return Container(
                  child: Center(
                    child: Text('You have not any data in wishlist yet.'),
                  ),
                  height: Get.height * 0.7,
                  width: Get.width,
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: wp.wishlists.length,
                    itemBuilder: (context, i) {
                      var product = wp.wishlists[i].product;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Container(
                            // height: 200,
                            width: Get.width,
                            // color: Colors.grey,
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(ProductDetails(product: product));
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: Get.width * 0.2,
                                              width: Get.width * 0.2,
                                              child: CachedNetworkImage(
                                                imageUrl: product.thumbnail!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor: Colors.white,
                                                  period: Duration(seconds: 1),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            product.thumbnail!),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor: Colors.white,
                                                  period: Duration(seconds: 1),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            product.thumbnail!),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Stack(
                                          children: [
                                            Container(
                                              // color: Colors.blue,
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    product.title!,
                                                    style: Get.theme.textTheme
                                                        .headline6,
                                                  ),
                                                  Text(product.description!,
                                                      style: Get.theme.textTheme
                                                          .caption),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          'brand:- ${product.brand!}',
                                                          style: Get
                                                              .theme
                                                              .textTheme
                                                              .bodyText2),
                                                      if (product.isPopular!)
                                                        Text(
                                                          'Popular',
                                                          style: Get
                                                              .theme
                                                              .textTheme
                                                              .bodyText2!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .pink),
                                                        ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '\$${product.price!}',
                                                        style: product.discountPercentage !=
                                                                    null ||
                                                                product.discountPercentage !=
                                                                    0
                                                            ? Get.theme.textTheme
                                                                .caption
                                                            : Get.theme.textTheme
                                                                .bodyText1,
                                                      ),
                                                      if (product.discountPercentage !=
                                                              null ||
                                                          product.discountPercentage !=
                                                              0)
                                                        Text(
                                                            '  \$${(product.price! * (100.00 - product.discountPercentage!) / 100).toStringAsFixed(2)}'),
                                                      if (product.discountPercentage !=
                                                              null ||
                                                          product.discountPercentage !=
                                                              0)
                                                        Text(
                                                            '  ${product.discountPercentage!}% off'),
                                                    ],
                                                  ),
                                                  if (product.discountPercentage !=
                                                          null ||
                                                      product.discountPercentage !=
                                                          0)
                                                    Row(
                                                      children: [
                                                        Text(
                                                            'offer available: ${product.discountPercentage != null || product.discountPercentage != 0 ? '${product.discountPercentage} % off' : 'No Offers'} '),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: IconButton(
                                                onPressed: () async {
                                                  AwesomeDialog(
                                                    context: context,
                                                    dialogType: DialogType.warning,
                                                    headerAnimationLoop: false,
                                                    animType: AnimType.topSlide,
                                                    showCloseIcon: true,
                                                    closeIcon: const Icon(Icons
                                                        .close_fullscreen_outlined),
                                                    title: 'Are you sure to remove',
                                                    desc:
                                                    'This item will no longer available in cart',
                                                    btnCancelOnPress: () {
                                                      Get.back();
                                                    },
                                                    onDismissCallback: (type) {
                                                      debugPrint(
                                                          'Dialog Dismiss from callback $type');
                                                    },
                                                    btnCancelText: "Cancel",
                                                    btnOkText: "Remove",
                                                    btnOkOnPress: () {
                                                      wp.deleteFromWishlist(product);
                                                      // widget.updateTotal();
                                                    },
                                                  ).show();

                                                  // cp.deleteFromCart(product);
                                                  // widget.updateTotal();
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 2,
                                                  spreadRadius: 0,
                                                  offset: Offset(0.5, 0.55),
                                                )
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 6),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Share',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(width: 20),
                                                Icon(
                                                  Icons.whatsapp,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green),
                                        onPressed: () {
                                          Provider.of<CartProvider>(context, listen: false)
                                              .addToCart(product, 0);
                                          Get.toNamed(Cart.route);

                                        },
                                        child: Text('Add to cart'),
                                      ),
                                      // SizedBox(width: 20),
                                      // ElevatedButton(
                                      //   style: ElevatedButton.styleFrom(
                                      //       primary: Colors.green),
                                      //   onPressed: () {},
                                      //   child: Row(
                                      //     children: [
                                      //       Text('Remove '),
                                      //       SizedBox(width: 5),
                                      //       Icon(Icons.delete),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }),
          ],
        ),
        bottomNavigationBar: DefaultBottomNav(),
      );
    });
  }
}
