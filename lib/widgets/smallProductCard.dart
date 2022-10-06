import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimmer/shimmer.dart';


import '../Providers/productProvider/productProvider.dart';

class SmallProductCard extends StatelessWidget {
  const SmallProductCard({
    Key? key,
    required this.product, required this.onTap, required this.addAction,
  }) : super(key: key);

  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback addAction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        imageUrl: product.images!.first,
        imageBuilder: (context, imageProvider) => Container(
          child: ClipRRect(
              borderRadius:
              BorderRadius.all(Radius.circular(5.0)),
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
                    top: 0.0,
                    left: 0.0,

                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF0233FA),
                            Color(0xFF0051FF),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(5),),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      child: Text(
                        '${product.discountPercentage!}%',
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
                        product.title!.capitalize!,
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

                    child: GestureDetector(
                      onTap: addAction,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Get.theme.backgroundColor
                              .withOpacity(1),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5.0),
                        child: Icon(Icons.add),
                      ),
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
                    image: NetworkImage(product.images!.first),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.red, BlendMode.color)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
