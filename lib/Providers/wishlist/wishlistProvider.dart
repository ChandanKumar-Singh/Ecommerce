import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/userModel.dart';
import '../productProvider/productProvider.dart';

class WishlistProvider extends ChangeNotifier {
  late SharedPreferences prefs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Wishlist> _wishlists = [];
  bool loading = false;
  List<Wishlist> get wishlists => _wishlists;

  void addToWishlist(ProductModel product, int quantity) async {
    if (_wishlists.any((element) => element.product.id == product.id)) {
      loading = true;
      _wishlists.removeWhere((element) => element.product.id == product.id);
      await removeFromWishlistFromDb(
          Wishlist(product: product, quantity: quantity));
      Fluttertoast.showToast(msg: 'Removed from wishlist.');

      notifyListeners();
    } else {
      loading = true;
      _wishlists.add(Wishlist(product: product, quantity: quantity));
      await addToWishlistInDb(Wishlist(product: product, quantity: quantity));
      Fluttertoast.showToast(msg: 'Added to wishlist.');
      notifyListeners();
    }
    loading = false;
    // print('Wish list length is ${wishlists.length}');
    notifyListeners();
  }

  Future<void> addToWishlistInDb(Wishlist wishlist) async {
    prefs = await SharedPreferences.getInstance();
    var user = Users.fromJson(jsonDecode(prefs.getString('user')!));
    CollectionReference ref = firestore
        .collection('ecommerce')
        .doc('admin')
        .collection('users')
        .doc(user.phone)
        .collection('wishlist');
    try {
      await ref.doc(wishlist.product.id.toString()).set(wishlist.toJson());
      // print('Item added to Your wishlist DB');
      // Fluttertoast.showToast(msg: 'Item added to Your wishlist DB');
    } on FirebaseException catch (e) {
      print(e.code);
      print(e.message);
    }
  }

  Stream<List<Wishlist>> getWishlist() async* {
    prefs = await SharedPreferences.getInstance();
    var user = Users.fromJson(jsonDecode(prefs.getString('user')!));
    CollectionReference ref = firestore
        .collection('ecommerce')
        .doc('admin')
        .collection('users')
        .doc(user.phone)
        .collection('wishlist');

    try {
      // print('Loading wishlist from db ');
      Stream<QuerySnapshot> snap = ref.snapshots();

      await for (var docs in snap) {
        _wishlists.clear();
        for (var doc in docs.docs) {
          print('snap data ${doc.data()}');
          var item = Wishlist.fromJson(doc.data() as Map<String, dynamic>);
          // print('cart item mapped');
          if (!_wishlists.any((wishlistItem) => wishlistItem.product.id == item.product.id)) {
            _wishlists.add(item);
            // print('Item Added to wishlist');
          }

          // print(
          //     '-------------------- got ${_wishlists.length} ---------------------------');
        }

        // print('Loading products from db $loading');
        // print(
        //     "0000000000000000000000000000000000000000000000000000000 ${_wishlists.length}");


        notifyListeners();
        yield _wishlists;
      }
    } on FirebaseException catch (e) {
      notifyListeners();
      print(e.code);
      print(e.message);
    }
  }

  Future<void> removeFromWishlistFromDb(Wishlist wishlist) async {
    prefs = await SharedPreferences.getInstance();
    var user = Users.fromJson(jsonDecode(prefs.getString('user')!));
    DocumentReference ref = firestore
        .collection('ecommerce')
        .doc('admin')
        .collection('users')
        .doc(user.phone)
        .collection('wishlist')
        .doc(wishlist.product.id.toString());
    try {
      await ref.delete();
      // print('Item removed from Your wishlist DB');
      // Fluttertoast.showToast(msg: 'Item removed from Your wishlist DB');
    } on FirebaseException catch (e) {
      print(e.code);
      print(e.message);
    }
  }

  void deleteFromWishlist(ProductModel product) async{
    var wishlistItem = _wishlists.firstWhere((element) {
      return element.product.id == product.id;
    });
    _wishlists.remove(wishlistItem);
    await removeFromWishlistFromDb(wishlistItem);
    Fluttertoast.showToast(msg: 'Item removed from wishlist');
    notifyListeners();
  }
}

class Wishlist {
  ProductModel product;
  int quantity = 0;
  Wishlist({required this.product, required this.quantity});

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
        product: ProductModel.fromJson(json['product']),
        quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['product'] = product.toJson();
    data['quantity'] = quantity;

    return data;
  }
}
