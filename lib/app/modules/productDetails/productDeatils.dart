import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_ecommerce_app/Providers/cart/cartProvider.dart';
import 'package:my_ecommerce_app/app/modules/whishList/wishlist.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Providers/productProvider/productProvider.dart';
import '../../../Providers/wishlist/wishlistProvider.dart';
import '../../../widgets/bottomNav.dart';
import '../../../widgets/topNav.dart';
import '../catlog/catlog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({required this.product});
  final ProductModel product;
  static const String route = '/details';
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late ProductModel product;
  bool addWishlist = false;
  int quantity = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product = widget.product;
    var wp = Provider.of<WishlistProvider>(context, listen: false);
    if (wp.wishlists.isNotEmpty) {
      addWishlist =
          wp.wishlists.any((element) => element.product.id == product.id);
    } else {
      addWishlist = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: kToolbarHeight),
          NavHeader(
              title: product.title!,
              route: WishList.route,
              icon: Icons.favorite_outlined),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          product.description!,
                          maxLines: 3,
                          style: Get.theme.textTheme.headline6,
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.3,
                    child: Stack(
                      children: [
                        CarouselWithIndicatorDemo(images: product.images!),
                        Consumer<WishlistProvider>(builder: (context, wp, _) {
                          print(wp.loading);
                          if (wp.loading) {
                            return CircularProgressIndicator();
                          } else {
                            return Positioned(
                              right: 30,
                              top: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                    color:
                                        addWishlist ? Colors.white : Colors.red,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 2,
                                        spreadRadius: 0,
                                        offset: Offset(0.5, 0.55),
                                      )
                                    ]),
                                child: IconButton(
                                    onPressed: () {
                                      // if (addWishlist) {
                                      //   // wp.wishlists.removeWhere((element) =>
                                      //   //     element.product.id == product.id);
                                      //   // print(wp.wishlists.length);
                                      // } else {
                                      //   wp.addToWishlist(product, 1);
                                      // }
                                      wp.addToWishlist(product, 1);
                                      // wp.wishlists!.add(Wishlist(product: product, quantity: 1));
                                      setState(() {
                                        addWishlist = !addWishlist;
                                      });
                                    },
                                    icon: addWishlist
                                        ? Icon(
                                            Icons.favorite_rounded,
                                            color: Colors.red,
                                          )
                                        : Icon(Icons.favorite_outline)),
                              ),
                            );
                          }
                        }),
                        Positioned(
                          right: 30,
                          top: 70,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: Offset(0.5, 0.55),
                                ),
                              ],
                            ),
                            child: IconButton(
                                onPressed: () {
                                  // setState(() {
                                  //   isWishlist = !isWishlist;
                                  // });
                                },
                                icon: Icon(Icons.share)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Category: ${product.category!}',
                          style: Get.theme.textTheme.bodyText1,
                        ),
                        Text(
                          '${product.brand!}',
                          style: Get.theme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('⭐ ${product.rating!}'),
                        Text(
                          'Price \$${product.price!}',
                          style: Get.theme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('In Stock ${product.stock!}',
                                style: Get.theme.textTheme.bodyText1!.copyWith(
                                    color: product.stock! < 20
                                        ? Colors.red
                                        : Colors.blue)),
                            Text(
                              'Product Id: ${product.id!}',
                              style: Get.theme.textTheme.bodyText1,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: product.isPopular!
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.end,
                          children: [
                            if (product.isPopular!)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.pink,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Popular',
                                    style: Get.theme.textTheme.bodyText1!
                                        .copyWith(),
                                  ),
                                ),
                              ),
                            Text(
                              'Discount: ${product.discountPercentage!}%',
                              style: Get.theme.textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                              product.title!,
                              maxLines: 3,
                              style: Get.theme.textTheme.headline6,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height * 0.1),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Share',
                            style: TextStyle(color: Colors.white),
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
                Expanded(
                  flex: 1,
                  child: Container(
                      // width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5),
                          color: Get.theme.backgroundColor),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity >= 2) {
                                  quantity--;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.remove,
                              color: Get.theme.textTheme.bodyText1!.color,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: Get.theme.textTheme.headline5,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Get.theme.textTheme.bodyText1!.color,
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(product, quantity);
                    },
                    child: Text('Add to cart'),
                  ),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Expanded(
          //           child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(primary: Colors.blue),
          //         onPressed: () {},
          //         child: Text('Go to cart'),
          //       )),
          //       SizedBox(width: 20),
          //       Expanded(
          //           child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(primary: Colors.green),
          //         onPressed: () {},
          //         child: Text('Add to cart'),
          //       )),
          //     ],
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: DefaultBottomNav(),
    );
  }
}

class CarouselWithIndicatorDemo extends StatefulWidget {
  CarouselWithIndicatorDemo({required this.images});
  final List<String> images;

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final List<Widget> imageSliders = widget.images
          .map((item) => GestureDetector(
                onTap: () {
                  // Get.toNamed(Catlog.route, arguments: item.category!);
                },
                child: CachedNetworkImage(
                  imageUrl: item,
                  imageBuilder: (context, imageProvider) => Container(
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                              // Positioned(
                              //   bottom: 0.0,
                              //   left: 0.0,
                              //   right: 0.0,
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //       gradient: LinearGradient(
                              //         colors: [
                              //           Color(0x34364934),
                              //           Color.fromARGB(0, 0, 0, 0)
                              //         ],
                              //         begin: Alignment.bottomCenter,
                              //         end: Alignment.topCenter,
                              //       ),
                              //     ),
                              //     padding: EdgeInsets.symmetric(
                              //         vertical: 10.0, horizontal: 20.0),
                              //     child: Text(
                              //       item.category!.capitalize!,
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 20.0,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ),
                              // ),
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
                            image: NetworkImage(item),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.white,
                      period: Duration(seconds: 1),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(item),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
          .toList();
      return Column(children: [
        Expanded(
          child: CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 30.0,
                height: 30.0,
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    // shape: BoxShape.rectangle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                child: CachedNetworkImage(
                  imageUrl: entry.value,
                  imageBuilder: (context, imageProvider) => Container(
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
                              image: NetworkImage(entry.value),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.red, BlendMode.color)),
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.white,
                      period: Duration(seconds: 1),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(entry.value),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.red, BlendMode.color)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ]);
    });
  }
}

class BuildPopularProducts extends StatelessWidget {
  const BuildPopularProducts({
    Key? key,
    required this.recProducts,
  }) : super(key: key);

  final List<ProductModel> recProducts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recProducts.length,
        itemBuilder: (context, i) {
         ProductModel product = recProducts[i];
          return Container(
            width: Get.width * 0.6,
            padding: EdgeInsets.only(right: 20, left: i == 0 ? 20 : 0),
            child: CachedNetworkImage(
              imageUrl: product.images!.first,
              imageBuilder: (context, imageProvider) => Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xC228FF71),
                                  Color(0x91FFA500),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              product.title!,
                              style: TextStyle(
                                color: Colors.white,
                                // fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          right: 10.0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Get.theme.backgroundColor.withOpacity(1),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    )),
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
                          image: NetworkImage(product.images!.first),
                          fit: BoxFit.cover,
                          colorFilter:
                              ColorFilter.mode(Colors.red, BlendMode.color)),
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  period: Duration(seconds: 1),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(product.images!.first),
                          fit: BoxFit.cover,
                          colorFilter:
                              ColorFilter.mode(Colors.red, BlendMode.color)),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BuildRecommendedProducts extends StatelessWidget {
  const BuildRecommendedProducts({
    Key? key,
    required this.recProducts,
  }) : super(key: key);

  final List<ProductModel> recProducts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recProducts.length,
        itemBuilder: (context, i) {
         ProductModel product = recProducts[i];
          return Container(
            width: Get.width * 0.6,
            padding: EdgeInsets.only(right: 20, left: i == 0 ? 20 : 0),
            child: CachedNetworkImage(
              imageUrl: product.images!.first,
              imageBuilder: (context, imageProvider) => Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xC228FF71),
                                  Color(0x91FFA500),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              product.title!,
                              style: TextStyle(
                                color: Colors.white,
                                // fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          right: 10.0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Get.theme.backgroundColor.withOpacity(1),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 5.0),
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    )),
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
                          image: NetworkImage(product.images!.first),
                          fit: BoxFit.cover,
                          colorFilter:
                              ColorFilter.mode(Colors.red, BlendMode.color)),
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  period: Duration(seconds: 1),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(product.images!.first),
                          fit: BoxFit.cover,
                          colorFilter:
                              ColorFilter.mode(Colors.red, BlendMode.color)),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
