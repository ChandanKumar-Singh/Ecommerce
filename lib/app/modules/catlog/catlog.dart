import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:my_ecommerce_app/app/modules/productDetails/productDeatils.dart';
import 'package:my_ecommerce_app/app/modules/whishList/wishlist.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Providers/productProvider/productProvider.dart';
import '../../../widgets/bottomNav.dart';
import '../../../widgets/smallProductCard.dart';
import '../../../widgets/topNav.dart';

class Catlog extends StatefulWidget {
  const Catlog({Key? key, required this.categogy}) : super(key: key);
  static const String route = '/catlog';
  final String categogy;

  @override
  State<Catlog> createState() => _CatlogState();
}

class _CatlogState extends State<Catlog> {
  List<ProductModel> allProducts = [];
  List<ProductModel> searchedList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var pp = Provider.of<ProductProvider>(context, listen: false);

    for (var p in pp.products) {
      allProducts = pp.products
          .where((element) => element.category == widget.categogy)
          .toList();
    }
    searchedList = allProducts;
    print(allProducts.length);
    print(searchedList.length);
  }

  @override
  Widget build(BuildContext context) {
    // print('-------------------- ${widget.categogy}');
    // print('-------------------- ${searchedList.length}');
    // return Consumer<ProductProvider>(builder: (context, pp, _) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: kToolbarHeight),
          NavHeader(
              route: WishList.route,
              title: widget.categogy,
              icon: Icons.favorite_outlined),
          SizedBox(height: Get.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Stack(
              children: [
                CupertinoSearchTextField(
                  // controller: searchController,

                  onChanged: (val) {
                    setState(() {
                      if (val.isNotEmpty) {
                        // print(val);
                        searchedList = allProducts.where(
                          (element) {
                            // print(element.title);
                            // print(val);

                            return element.title!
                                .toLowerCase()
                                .contains(val.toLowerCase());
                          },
                        ).toList();
                      } else {
                        searchedList = allProducts;
                      }
                      // print('${searchedList.length}  Searching');
                      // print('${allProducts.length}  all');
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              itemCount: searchedList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, i) {
                ProductModel product = searchedList[i];
                return SmallProductCard(
                  product: product,
                  addAction: () {},
                  onTap: () {
                    Get.toNamed(ProductDetails.route, arguments: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: DefaultBottomNav(),
    );
    // });
  }
}

