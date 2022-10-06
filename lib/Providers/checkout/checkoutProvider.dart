import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_ecommerce_app/Models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../productProvider/productProvider.dart';

class CheckoutProvider extends ChangeNotifier {
  late SharedPreferences prefs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<CheckoutItem> _checkoutItems = [];
  bool loading = false;
  List<CheckoutItem> get checkoutItems => _checkoutItems;
  late Users user;

  void addToCheckout(ProductModel product, int quantity) async {
    if (quantity != 0) {
      await getUserData();
      if (_checkoutItems.any((element) => element.product.id == product.id)) {
        loading = true;
        notifyListeners();
        var checkoutItem = _checkoutItems.firstWhere((element) {
          return element.product.id == product.id;
        });
        //check for quantity <5
        if (checkoutItem.quantity + quantity > 5) {
          Fluttertoast.showToast(
              msg: 'Already ${checkoutItem.quantity} in checkout');
          Fluttertoast.showToast(
              msg: 'You can only add ${5 - checkoutItem.quantity} more');
        } else {
          // <5 then add to that one
          checkoutItem.quantity += quantity;
          var index = _checkoutItems.indexWhere((element) {
            return element.product.id == product.id;
          });
          _checkoutItems.removeAt(index);
          _checkoutItems.insert(index, checkoutItem);
          // await addToCartInDb(checkoutItem);
          Fluttertoast.showToast(msg: 'Added to checkout');
          notifyListeners();
        }
      } else {
        if (quantity > 5) {
          Fluttertoast.showToast(msg: 'You can only add 5 in checkout');
        } else {
          loading = true;
          _checkoutItems
              .add(CheckoutItem(product: product, quantity: quantity));
          // await addToCartInDb(CheckoutItem(product: product, quantity: quantity));
          Fluttertoast.showToast(msg: 'Added to checkout');
          notifyListeners();
        }
      }
    } else {
      // print('Skiped due to ${product.title} 0 quantity');
    }
    loading = false;

    // print('Checkout length is ${checkoutItems.length}');
    notifyListeners();
  }

  void deleteFromCheckout(ProductModel product) async {
    var cartItem = _checkoutItems.firstWhere((element) {
      return element.product.id == product.id;
    });
    checkoutItems.remove(cartItem);
    // await removeFromCartFromDb(cartItem);
    Fluttertoast.showToast(msg: 'Item removed from cart');
    notifyListeners();
  }

  Future<void> getUserData() async {
    prefs = await SharedPreferences.getInstance();
    user = Users.fromJson(jsonDecode(prefs.getString('user')!));
    DocumentReference ref = firestore
        .collection('ecommerce')
        .doc('admin')
        .collection('users')
        .doc(user.phone.toString());
    try {
      var data = await ref.get();
      // print(data.data());
      user = Users.fromJson(data.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> saveOrderHistory() async {

    CollectionReference ref = firestore
        .collection('ecommerce')
        .doc('admin')
        .collection('users')
        .doc(user.phone)
        .collection('order_history');
    checkoutItems.forEach((element) async {
      OrederHistory orederHistory = OrederHistory(
          product: element.product,
          quantity: element.quantity,
          orderedAt: DateTime.now().toString());
      try{
        await ref.doc(orederHistory.orderedAt).set(orederHistory.toJson());
      }catch(e){
        print('Order history $e');
      }
    });
    notifyListeners();
  }
}

class CheckoutItem {
  ProductModel product;
  int quantity = 0;
  CheckoutItem({required this.product, required this.quantity});

  factory CheckoutItem.fromJson(Map<String, dynamic> json) {
    return CheckoutItem(
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

class OrederHistory {
  ProductModel product;
  int quantity = 0;
  String orderedAt;
  OrederHistory(
      {required this.product, required this.quantity, required this.orderedAt});

  factory OrederHistory.fromJson(Map<String, dynamic> json) {
    return OrederHistory(
        product: ProductModel.fromJson(json['product']),
        quantity: json['quantity'],
        orderedAt: json['orderedAt']);
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['product'] = product.toJson();
    data['quantity'] = quantity;
    data['orderedAt'] = orderedAt;

    return data;
  }
}
