import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:my_ecommerce_app/AppInfo/appInfo.dart';
import 'package:my_ecommerce_app/Providers/Category.dart';
import 'package:my_ecommerce_app/Providers/authProvider/authProvider.dart';
import 'package:my_ecommerce_app/Providers/cart/cartProvider.dart';
import 'package:my_ecommerce_app/app/modules/whishList/wishlist.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Providers/BottomNavProvider.dart';
import '../../../../Providers/productProvider/productProvider.dart';
import '../../../../widgets/bottomNav.dart';
import '../../../../widgets/smallProductCard.dart';
import '../../catlog/catlog.dart';
import '../../productDetails/productDeatils.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void init() async {
    await Provider.of<AuthProvider>(context, listen: false).checkLogin();
    // Provider.of<ProductProvider>(context, listen: false).users.forEach((element) async{
    //   await   Provider.of<ProductProvider>(context, listen: false).addUsersToDB(element);
    // });
    // await setToDB(
    //     Provider.of<ProductProvider>(context, listen: false).products);
    //  Provider.of<ProductProvider>(context, listen: false).getAllProductsFromDB().asBroadcastStream();
  }

  Future<void> setToDB(List<ProductModel> products) async =>
      products.forEach((element) async {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProductsToDB(element);
      });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();

    Provider.of<ProductProvider>(context, listen: false)
        .getAllProductsFromDB()
        .asBroadcastStream()
        .listen((event) {});
    Provider.of<CartProvider>(context, listen: false)
        .getCart()
        .asBroadcastStream()
        .listen((event) {});
    Provider.of<BottomNavProvider>(context, listen: false).curIndex = 0;
    print(Provider.of<BottomNavProvider>(context, listen: false).curIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, pp, _) {
      if (pp.loading) {
        return Scaffold(
          body: Container(
            height: Get.height,
            width: Get.width,
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight),
                Row(
                  children: [
                    Spacer(flex: 2),
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
                              AppInfo.appName,
                              style: Get.theme.textTheme.headline5!.copyWith(
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
                          Get.toNamed(WishList.route);
                        },
                        icon: Icon(
                          Icons.favorite_rounded,
                          color: Get.theme.backgroundColor.withOpacity(1),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Shimmer(
                  gradient:
                      LinearGradient(colors: [Colors.white, Colors.black]),
                  child: Container(
                    height: Get.height * 0.7,
                    width: Get.width,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: DefaultBottomNav(),
        );
      } else {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight),
                Row(
                  children: [
                    Spacer(flex: 2),
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
                              AppInfo.appName,
                              style: Get.theme.textTheme.headline5!.copyWith(
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
                          Get.toNamed(WishList.route);
                        },
                        icon: Icon(
                          Icons.favorite_rounded,
                          color: Get.theme.backgroundColor.withOpacity(1),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: Get.height * 0.3,
                  child: Stack(
                    children: [
                      CarouselWithIndicatorDemo(),
                      Positioned(
                        top: 0,
                        right: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Get.theme.backgroundColor.withOpacity(1),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                showSearch(
                                    context: context,
                                    delegate: CustomSearchDelegate());
                              });
                            },
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Recommended',
                        style: Get.theme.textTheme.headline5!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Builder(builder: (context) {
                  List<ProductModel> recProducts = pp.products
                      .where((element) => element.isRecommended == true)
                      .toList();
                  return BuildRecommendedProducts(recProducts: recProducts);
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Popular',
                        style: Get.theme.textTheme.headline5!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Builder(builder: (context) {
                  List<ProductModel> recProducts = pp.products
                      .where((element) => element.isPopular == true)
                      .toList();
                  return BuildPopularProducts(recProducts: recProducts);
                }),
                SizedBox(height: Get.height * 0.1),
              ],
            ),
          ),
          bottomNavigationBar: DefaultBottomNav(),
        );
      }
    });
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using
    // InheritedBlocs.of(context)
    //     .searchBloc
    //     .searchTerm
    //     .add(query);

    return Column(
      children: <Widget>[
        //Build the results based on the searchResults stream in the searchBloc
        StreamBuilder(
          // stream: InheritedBlocs.of(context).searchBloc.searchResults,
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (!snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.data!.isEmpty) {
              return Column(
                children: <Widget>[
                  Text(
                    "No Results Found.",
                  ),
                ],
              );
            } else {
              var results = snapshot.data;
              return ListView.builder(
                itemCount: results!.length,
                itemBuilder: (context, index) {
                  var result = results[index];
                  return ListTile(
                      // title: Text(result),
                      );
                },
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column(
      children: [
        Text('This is suggestions'),
      ],
    );
  }
}

class CarouselWithIndicatorDemo extends StatefulWidget {
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
    return Consumer<ProductProvider>(builder: (context, pp, _) {
      List<ProductModel> categories = [];
      for (var p in pp.categories) {
        if (!categories.any((ele) => ele.category == p)) {
          categories
              .add(pp.products.firstWhere((element) => element.category == p));
        }
      }
      final List<Widget> imageSliders = categories
          .map((item) => GestureDetector(
                onTap: () {
                  Get.toNamed(Catlog.route, arguments: item.category!);
                },
                child: CachedNetworkImage(
                  imageUrl: item.images!.first,
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
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0x34364934),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Text(
                                    item.category!.capitalize!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                              image: NetworkImage(item.images!.first),
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
                              image: NetworkImage(item.images!.first),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.red, BlendMode.color)),
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
          children: categories.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
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
            child: SmallProductCard(
              product: product,
              onTap: () {
                Get.toNamed(ProductDetails.route, arguments: product);
              },
              addAction: () {},
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
            child: Padding(
              padding: EdgeInsets.only(right: 20, left: i == 0 ? 20 : 0),
              child: SmallProductCard(
                product: product,
                onTap: () {
                  Get.toNamed(ProductDetails.route, arguments: product);
                },
                addAction: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
