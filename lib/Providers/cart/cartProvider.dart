import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_ecommerce_app/Models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../productProvider/productProvider.dart';

class CartProvider extends ChangeNotifier {
  late SharedPreferences prefs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<CartItem> _cartItems = [];
  bool loading = false;
  List<CartItem> get cartItems => _cartItems;

  void addToCart(ProductModel product, int quantity) async {
    if (_cartItems.any((element) => element.product.id == product.id)) {
      loading = true;
      notifyListeners();
      var cartItem = _cartItems.firstWhere((element) {
        return element.product.id == product.id;
      });
      //check for quantity <5
      if (cartItem.quantity + quantity > 5) {
        Fluttertoast.showToast(msg: 'Already ${cartItem.quantity} in cart');
        Fluttertoast.showToast(
            msg: 'You can only add ${5 - cartItem.quantity} more');
      } else {
        // <5 then add to that one
        cartItem.quantity += quantity;
        var index = _cartItems.indexWhere((element) {
          return element.product.id == product.id;
        });
        _cartItems.removeAt(index);
        _cartItems.insert(index, cartItem);
        await addToCartInDb(cartItem);
        Fluttertoast.showToast(msg: 'Added to cart');
        notifyListeners();
      }
    } else {
      if (quantity > 5) {
        Fluttertoast.showToast(msg: 'You can only add 5 in cart');
      } else {
        loading = true;
        _cartItems.add(CartItem(product: product, quantity: quantity));
        await addToCartInDb(CartItem(product: product, quantity: quantity));
        Fluttertoast.showToast(msg: 'Added to cart');
        notifyListeners();
      }
    }
    loading = false;

    // print('Wish list length is ${cartItems.length}');
    notifyListeners();
  }

  Future<void> addToCartInDb(CartItem cartItem) async {
    prefs = await SharedPreferences.getInstance();
    var user = Users.fromJson(jsonDecode(prefs.getString('user')!));
    CollectionReference ref = firestore
        .collection('ecommerce')
        .doc('admin')
        .collection('users')
        .doc(user.phone)
        .collection('cart');
    try {
      await ref.doc(cartItem.product.id.toString()).set(cartItem.toJson());
      // print('Item added to Your cart DB');
      // Fluttertoast.showToast(msg: 'Item added to Your cart DB');
    } on FirebaseException catch (e) {
      print(e.code);
      print(e.message);
    }
  }

  Stream<List<CartItem>> getCart() async* {
    prefs = await SharedPreferences.getInstance();
    var user = Users.fromJson(jsonDecode(prefs.getString('user')!));
    CollectionReference ref = firestore
        .collection('ecommerce')
        .doc('admin')
        .collection('users')
        .doc(user.phone)
        .collection('cart');

    try {
      // print('Loading cart from db ');
      Stream<QuerySnapshot> snap = ref.snapshots();

      await for (var docs in snap) {
        _cartItems.clear();
        for (var doc in docs.docs) {
          // print('snap data ${doc.data()}');
          var item = CartItem.fromJson(doc.data() as Map<String, dynamic>);
          // print('cart item mapped');
          if (!_cartItems.any((cart) => cart.product.id == item.product.id)) {
            _cartItems.add(item);
            // print('Item Added to cart');
          }

          // print(
          //     '-------------------- got ${_cartItems.length} ---------------------------');
        }

        // print('Loading products from db $loading');
        // print(
        //     "0000000000000000000000000000000000000000000000000000000 ${_cartItems.length}");


        notifyListeners();
        yield _cartItems;
      }
    } on FirebaseException catch (e) {
      notifyListeners();
      print(e.code);
      print(e.message);
    }
  }
  Future<void> removeFromCartFromDb(CartItem cartItem) async {
    prefs = await SharedPreferences.getInstance();
    var user = Users.fromJson(jsonDecode(prefs.getString('user')!));
    DocumentReference ref = firestore
        .collection('ecommerce')
        .doc('admin')
        .collection('users')
        .doc(user.phone)
        .collection('cart')
        .doc(cartItem.product.id.toString());
    try {
      await ref.delete();
      // print('Item removed from Your cart DB');
      // Fluttertoast.showToast(msg: 'Item removed from Your cart DB');
    } on FirebaseException catch (e) {
      print(e.code);
      print(e.message);
    }
  }

  void deleteFromCart(ProductModel product) async{
    var cartItem = _cartItems.firstWhere((element) {
      return element.product.id == product.id;
    });
    cartItems.remove(cartItem);
    await removeFromCartFromDb(cartItem);
    Fluttertoast.showToast(msg: 'Item removed from cart');
    notifyListeners();
  }
}

class CartItem {
  ProductModel product;
  int quantity = 0;
  CartItem({required this.product, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
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
