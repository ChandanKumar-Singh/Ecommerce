import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_ecommerce_app/Providers/wishlist/wishlistProvider.dart';
import 'package:my_ecommerce_app/app/modules/CheckOut/addPayment.dart';
import 'package:my_ecommerce_app/app/routes/app_pages.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Providers/cart/cartProvider.dart';
import '../../../Providers/checkout/checkoutProvider.dart';
import '../../../widgets/bottomNav.dart';
import '../Basket/Basket.dart';
import '../productDetails/productDeatils.dart';

class OrderConfirmation extends StatefulWidget {
  const OrderConfirmation({Key? key}) : super(key: key);
  static const String route = '/orderConfirmation';

  @override
  State<OrderConfirmation> createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  Future<bool> deleteCheckout() async {
    Provider.of<CheckoutProvider>(context, listen: false).checkoutItems.clear();
    Get.offNamed(AppPages.CART);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: deleteCheckout,
      child: Scaffold(
        body: Stack(
          children: [
            Container(height: Get.height, width: Get.width),
            Positioned(
              child: Container(
                height: Get.height * 0.4,
                color: Get.theme.backgroundColor.withOpacity(0.8),
              ),
            ),
            Column(
              children: [
                SizedBox(height: kToolbarHeight),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: IconButton(
                        onPressed: () {
                          Provider.of<WishlistProvider>(context, listen: false)
                              .wishlists
                              .clear();
                          Get.offAllNamed(AppPages.HOME);
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
                          color: Get.theme.backgroundColor.withOpacity(1),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Order Confirmation',
                              style: Get.theme.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
                // Image.asset('assets/orderConfirm/Order-confirmed4.png',color: Colors.white,),
                // Image.asset('assets/orderConfirm/Order-confirmed1.png',),
                // Image.asset('assets/orderConfirm/Order-confirmed2.png'),
                Image.asset('assets/orderConfirm/Order-confirmed3.png'),
                Expanded(
                  child: Consumer<CheckoutProvider>(builder: (context, cop, _) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BuildOrderedItem(
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
          ],
        ),

      ),
    );
  }
}

class BuildOrderedItem extends StatefulWidget {
  const BuildOrderedItem(
      {Key? key, required this.cop, required this.updateTotal})
      : super(key: key);
  final CheckoutProvider cop;
  final VoidCallback updateTotal;

  @override
  State<BuildOrderedItem> createState() => _BuildOrderedItemState();
}

class _BuildOrderedItemState extends State<BuildOrderedItem> {
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
            'Go to shop add items and checkout.',
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ));
      } else {
        var address = cop.user.address;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivered to: ',
                        style: Get.theme.textTheme.bodyText1,
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
                              '${address!.postalCode! ?? ''} ' +
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Order Details',
                  style: Get.theme.textTheme.headline6,
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
                              // Get.to(ProductDetails(product: product));
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
                                            if (product.discountPercentage ==
                                                null ||
                                                product.discountPercentage == 0)
                                            Text(
                                              'Total: \$${(product.price!) * (quantity != 0 ? quantity : e.quantity)}',
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
                                                  'Total: \$${(((product.price! * (100.00 - product.discountPercentage!) / 100)) * (quantity != 0 ? quantity : e.quantity)).toStringAsFixed(2)}'),

                                          ],
                                        ),


                                      ],
                                    ),
                                  ),
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
                                    Provider.of<WishlistProvider>(context,
                                            listen: false)
                                        .wishlists
                                        .clear();
                                    Get.offAllNamed(AppPages.HOME);
                                  },
                                  child: Text('Shop More'),
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
