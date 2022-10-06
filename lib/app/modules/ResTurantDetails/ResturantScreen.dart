import 'package:flutter/material.dart'
;

class ResturantScreen extends StatelessWidget {
  const ResturantScreen({Key? key}) : super(key: key);
  static const String route ='/location';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resturant'),),
    );
  }
}