import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_ecommerce_app/app/modules/CheckOut/orederPlaced.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Providers/checkout/checkoutProvider.dart';
import '../../../widgets/bottomNav.dart';
import '../productDetails/productDeatils.dart';

import 'package:flutter_credit_card/flutter_credit_card.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);
  static const String route = '/payment';

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
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
                        'Payment',
                        style: Get.theme.textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
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
              var address = cop.user.address;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (address != null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delivery to: ',
                                style: Get.theme.textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${cop.user.firstName! ?? ''} ' +
                                          '${cop.user.maidenName! ?? ' '} ' +
                                          '${cop.user.lastName! ?? ' '}',
                                      maxLines: 2,
                                      style: Get.theme.textTheme.headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Email: ${cop.user.email!}' ??
                                          'Email not attached',
                                      maxLines: 2,
                                      style: Get.theme.textTheme.bodyText2,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Text(
                                      'Change',
                                      style: Get.theme.textTheme.bodyText1,
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
                      child: CreditCardWidget(
                        cardNumber: cop.user.bank!.cardNumber!,
                        expiryDate: cop.user.bank!.cardExpire!,
                        cardHolderName:
                            '${cop.user.firstName! ?? ''} ${cop.user.maidenName! ?? ' '} ${cop.user.lastName! ?? ' '}',
                        cvvCode: "***",
                        showBackView: false,
                        onCreditCardWidgetChange:
                            (CreditCardBrand) {}, //true when you want to show cvv(back) view
                      ),
                    ),
                    SizedBox(height: 10),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            // width: Get.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () async {
                                // Provider.of<CartProvider>(context, listen: false)
                                //     .addToCart(product, quantity);
                            await    cop.saveOrderHistory();
                                Get.toNamed(OrderConfirmation.route);
                              },
                              child: Text('ORDER'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: DefaultBottomNav(),
    );
  }
}
