import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_ecommerce_app/Providers/BottomNavProvider.dart';
import 'package:my_ecommerce_app/Providers/cart/cartProvider.dart';
import 'package:my_ecommerce_app/app/modules/CheckOut/CheckOut.dart';
import 'package:my_ecommerce_app/app/modules/productDetails/productDeatils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Providers/checkout/checkoutProvider.dart';
import '../../../widgets/bottomNav.dart';
import '../../../widgets/topNav.dart';
import '../catlog/catlog.dart';
import '../whishList/wishlist.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);
  static const String route = '/cart';

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<BottomNavProvider>(context, listen: false).curIndex = 1;
    print(Provider.of<BottomNavProvider>(context, listen: false).curIndex);
  }

  Future<bool> setOnWilPop() async {
    Provider.of<BottomNavProvider>(context, listen: false).curIndex = 0;
    return true;
  }

  // int total = 0;
  // int quantity = 0;
  // String get subtotalString => subtotal().toStringAsFixed(2);
  // String get deliveryFeeString => deliveryFee(subtotal()).toStringAsFixed(2);

  String subtotal(List<CartItem> cartItems) {
    double total = 0;
    for (var element in cartItems) {
      if (element.product.discountPercentage != null ||
          element.product.discountPercentage != 0) {
        var disPrice = (element.product.price! *
            (100.00 - element.product.discountPercentage!) /
            100);
        total += (element.quantity * disPrice);
      } else {
        total += (element.quantity * element.product.price!);
      }
    }
    // setState(() {});
    print('Total price for all items in cart is $total');
    // notifyListeners();
    return total.toStringAsFixed(2);
  }

  double deliveryFee(double subtotal) {
    if (subtotal >= 20||subtotal==0) {
      return 0.00;
    } else {
      return 5.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cp, _) {
      // double total = 0;
      //
      // for (var element in cp.cartItems) {
      //   if (element.product.discountPercentage != null ||
      //       element.product.discountPercentage != 0) {
      //     var disPrice = (element.product.price! *
      //         (100.00 - element.product.discountPercentage!) /
      //         100);
      //     total += (element.quantity * disPrice);
      //   } else {
      //     total += (element.quantity * element.product.price!);
      //   }
      // }

      return Scaffold(
        body: Column(
          children: [
            SizedBox(height: kToolbarHeight),
            NavHeader(
                title: 'Cart',
                route: WishList.route,
                icon: Icons.favorite_outlined),
            if ((20.0 - double.parse(subtotal(cp.cartItems)) > 0))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        'Add \$${20.0 - double.parse(subtotal(cp.cartItems))} for free delivery',
                        style: Get.theme.textTheme.bodyText1),
                    ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed('/home');
                      },
                      child: Text('Add more items'),
                    ),
                  ],
                ),
              ),
            BuildCartItem(
              cp: cp,
              updateTotal: () {
                setState(() {});
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), side: BorderSide()),
                // color: Get.theme.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SUBTOTAL',
                                    // style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    '\$${subtotal(cp.cartItems)}',
                                    // style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'DELIVERY FEE',
                                    // style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    '\$${deliveryFee(double.parse(subtotal(cp.cartItems)))}',
                                    // style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'TOTAL',
                                    style: Get.theme.textTheme.bodyText1!
                                        .copyWith(fontWeight: FontWeight.bold),
                                    // style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    '\$${subtotal(cp.cartItems)}',
                                    style: Get.theme.textTheme.bodyText1!
                                        .copyWith(fontWeight: FontWeight.bold),
                                    // style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        width: Get.width * 0.4,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {
                            cp.cartItems.forEach((element) {
                              Provider.of<CheckoutProvider>(context,listen: false).addToCheckout(element.product, element.quantity);
                            });
                            // Provider.of<CartProvider>(context, listen: false)
                            //     .addToCart(product, quantity);
                            Get.toNamed(Checkout.route);
                          },
                          child: Text('Place Order'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: DefaultBottomNav(),
      );
    });
  }
}

class BuildCartItem extends StatefulWidget {
  const BuildCartItem({Key? key, required this.cp, required this.updateTotal})
      : super(key: key);
  final CartProvider cp;
  final VoidCallback updateTotal;

  @override
  State<BuildCartItem> createState() => _BuildCartItemState();
}

class _BuildCartItemState extends State<BuildCartItem> {
  late CartProvider cp;
  // int quantity = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cp = widget.cp;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (cp.cartItems.isEmpty) {
        return Expanded(
            child: Center(
          child: Text(
            'You have not any data in your Basket yet.',
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ));
      } else {
        return Expanded(
          child: ListView.builder(
            itemCount: cp.cartItems.length,
            itemBuilder: (context, i) {
              var product = cp.cartItems[i].product;
              var quantity = cp.cartItems[i].quantity;
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
                                        errorWidget: (context, url, error) =>
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            product.title!,
                                            style:
                                                Get.theme.textTheme.headline6,
                                          ),
                                          Text(product.description!,
                                              style:
                                                  Get.theme.textTheme.caption),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('brand:- ${product.brand!}',
                                                  style: Get.theme.textTheme
                                                      .bodyText2),
                                              if (product.isPopular!)
                                                Text(
                                                  'Popular',
                                                  style: Get.theme.textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                          color: Colors.pink),
                                                ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '\$${(product.price!) * (quantity != 0 ? quantity : cp.cartItems[i].quantity)}',
                                                style: product.discountPercentage !=
                                                            null ||
                                                        product.discountPercentage !=
                                                            0
                                                    ? Get
                                                        .theme.textTheme.caption
                                                    : Get.theme.textTheme
                                                        .bodyText1,
                                              ),
                                              if (product.discountPercentage !=
                                                      null ||
                                                  product.discountPercentage !=
                                                      0)
                                                Text(
                                                    '  \$${(((product.price! * (100.00 - product.discountPercentage!) / 100)) * (quantity != 0 ? quantity : cp.cartItems[i].quantity)).toStringAsFixed(2)}'),
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
                                              product.discountPercentage != 0)
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
                                              cp.deleteFromCart(product);
                                              widget.updateTotal();
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PopupMenuButton<int>(
                                padding: EdgeInsets.all(0),
                                itemBuilder: (context) {
                                  return [
                                    ...[1, 2, 3, 4, 5].map(
                                      (e) => PopupMenuItem(
                                        child: Text(
                                          e.toString(),
                                        ),
                                        onTap: () {
                                          // print(e);
                                          setState(() {
                                            cp.cartItems
                                                .firstWhere((element) =>
                                                    element.product.id ==
                                                    product.id)
                                                .quantity = e;
                                          });
                                          widget.updateTotal();
                                          // cp.addToCart(product, quantity);
                                          print(cp.cartItems
                                              .firstWhere((element) =>
                                                  element.product.id ==
                                                  product.id)
                                              .quantity);
                                        },
                                      ),
                                    ),
                                  ];
                                },
                                onSelected: (i) {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    // color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 6),
                                    child: Text(
                                      'Qty ${quantity != 0 ? quantity : cp.cartItems[i].quantity}',
                                      style: TextStyle(),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green),
                                onPressed: () {
                                  Provider.of<CheckoutProvider>(context,listen: false).addToCheckout(product, quantity);
                                  Get.toNamed(Checkout.route);
                                },
                                child: Text('⚡ Buy this now'),
                              ),
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
    });
  }
}
