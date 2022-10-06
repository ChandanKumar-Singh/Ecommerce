import 'package:flutter/material.dart'
;

class ResturantRatings extends StatelessWidget {
  const ResturantRatings({Key? key}) : super(key: key);
  static const String route ='/location';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ResturantRatings'),),
    );
  }
}