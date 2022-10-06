import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_ecommerce_app/app/modules/CheckOut/addPayment.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Providers/cart/cartProvider.dart';
import '../../../Providers/checkout/checkoutProvider.dart';
import '../../../widgets/bottomNav.dart';
import '../Basket/Basket.dart';
import '../productDetails/productDeatils.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);
  static const String route = '/checkout';

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  Future<bool> deleteCheckout() async {
    Provider.of<CheckoutProvider>(context, listen: false).checkoutItems.clear();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: deleteCheckout,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: kToolbarHeight),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: () {
                      Provider.of<CheckoutProvider>(context, listen: false)
                          .checkoutItems
                          .clear();
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
                          'Checkout',
                          style: Get.theme.textTheme.headline5!
                              .copyWith(fontWeight: FontWeight.bold,color: Colors.white),
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
            Expanded(
              child: Consumer<CheckoutProvider>(builder: (context, cop, _) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BuildCheckOutItem(
                    cop: cop,
                    updateTotal: () {
                      setState(() {});
                    },
                  ),
                );
              }),
            ),
          ],
        ),
        bottomNavigationBar: DefaultBottomNav(),
      ),
    );
  }
}

class BuildCheckOutItem extends StatefulWidget {
  const BuildCheckOutItem(
      {Key? key, required this.cop, required this.updateTotal})
      : super(key: key);
  final CheckoutProvider cop;
  final VoidCallback updateTotal;

  @override
  State<BuildCheckOutItem> createState() => _BuildCheckOutItemState();
}

class _BuildCheckOutItemState extends State<BuildCheckOutItem> {
  late CheckoutProvider cop;
  String subtotal(List<CheckoutItem> checkoutItems) {
    double total = 0;
    for (var element in checkoutItems) {
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
    if (subtotal >= 20 || subtotal == 0) {
      return 0.00;
    } else {
      return 5.0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cop = widget.cop;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (cop.checkoutItems.isEmpty) {
        return Expanded(
            child: Center(
          child: Text(
            'You have not any data in your Checkout yet.',
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ));
      } else {
        var address = cop.user.address;
        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  if (address == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          'Add Address',
                          style: Get.theme.textTheme.bodyText1,
                        ),
                      ),
                    ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              if (address != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Delivery to: ',
                              style: Get.theme.textTheme.bodyText1,
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              child: Text(
                                'Change',
                                style: Get.theme.textTheme.bodyText1,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${cop.user.firstName! ?? ''} ' +
                                    '${cop.user.maidenName! ?? ' '} ' +
                                    '${cop.user.lastName! ?? ' '}',
                                maxLines: 2,
                                style: Get.theme.textTheme.headline6!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${address.postalCode! ?? ''} ' +
                                    '${address.city! ?? ' '} ' +
                                    '${address.address! ?? ' '} ' +
                                    '${address.coordinates!.toJson() ?? ' '}',
                                maxLines: 2,
                                style: Get.theme.textTheme.bodyText2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          cop.user.phone!,
                          maxLines: 2,
                          style: Get.theme.textTheme.bodyText1,
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              if ((20.0 - double.parse(subtotal(cop.checkoutItems)) > 0))
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          'Add \$${20.0 - double.parse(subtotal(cop.checkoutItems))} for free delivery',
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
              ...cop.checkoutItems.map((e) {
                var product = e.product;
                var quantity = e.quantity;
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
                                  child: Container(
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
                                          style: Get.theme.textTheme.headline6,
                                        ),
                                        Text(product.description!,
                                            style: Get.theme.textTheme.caption),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('brand:- ${product.brand!}',
                                                style: Get
                                                    .theme.textTheme.bodyText2),
                                            if (product.isPopular!)
                                              Text(
                                                'Popular',
                                                style: Get
                                                    .theme.textTheme.bodyText2!
                                                    .copyWith(
                                                        color: Colors.pink),
                                              ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '\$${(product.price!) * (quantity != 0 ? quantity : e.quantity)}',
                                              style: product.discountPercentage !=
                                                          null ||
                                                      product.discountPercentage !=
                                                          0
                                                  ? Get.theme.textTheme.caption
                                                  : Get.theme.textTheme
                                                      .bodyText1,
                                            ),
                                            if (product.discountPercentage !=
                                                    null ||
                                                product.discountPercentage != 0)
                                              Text(
                                                  '  \$${(((product.price! * (100.00 - product.discountPercentage!) / 100)) * (quantity != 0 ? quantity : e.quantity)).toStringAsFixed(2)}'),
                                            if (product.discountPercentage !=
                                                    null ||
                                                product.discountPercentage != 0)
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
                                              cop.checkoutItems
                                                  .firstWhere((element) =>
                                                      element.product.id ==
                                                      product.id)
                                                  .quantity = e;
                                            });
                                            widget.updateTotal();
                                            // cp.addToCart(product, quantity);
                                            print(cop.checkoutItems
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
                                        'Qty ${quantity != 0 ? quantity : e.quantity}',
                                        style: TextStyle(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green),
                                  onPressed: () async {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      headerAnimationLoop: false,
                                      animType: AnimType.topSlide,
                                      showCloseIcon: true,
                                      closeIcon: const Icon(
                                          Icons.close_fullscreen_outlined),
                                      title: 'Are you sure to remove',
                                      desc:
                                          'This item will no longer available in checkout',
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
                                        cop.deleteFromCheckout(product);
                                        widget.updateTotal();
                                      },
                                    ).show();
                                  },
                                  child: Text('Remove this item'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide()),
                  // color: Get.theme.backgroundColor,
                  child: Container(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
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
                                        '\$${subtotal(cop.checkoutItems)}',
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
                                        '\$${deliveryFee(double.parse(subtotal(cop.checkoutItems)))}',
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
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                        // style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        '\$${subtotal(cop.checkoutItems)}',
                                        style: Get.theme.textTheme.bodyText1!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                        // style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Row(
                            children: [
                              Expanded(
                                // width: Get.width,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(),
                                  onPressed: () {
                                    // Provider.of<CartProvider>(context, listen: false)
                                    //     .addToCart(product, quantity);
                                    Get.toNamed(PaymentPage.route);
                                  },
                                  child: Text('Continue'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
