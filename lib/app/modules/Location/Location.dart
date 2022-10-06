// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:food_delivery_app/bloc/autoComplete/autoComplete_bloc.dart';
// import 'package:food_delivery_app/bloc/autoComplete/autocomplete_event.dart';
// import 'package:food_delivery_app/bloc/autoComplete/autocomplete_state.dart';
// import 'package:food_delivery_app/bloc/geoLocation/geolocation_bloc.dart';
// import 'package:food_delivery_app/bloc/geoLocation/geolocationstate.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
//
// class LocationScreen extends StatelessWidget {
//   LocationScreen({Key? key}) : super(key: key);
//   static const String route = '/location';
//   final Completer<GoogleMapController> _controller = Completer();
//   Position? curPosition;
//
//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<GeolocationBloc, GeolocationState>(
//           builder: (context, state) {
//         if (state is GeoLoactionLoading) {
//           return Center(
//             child: CupertinoActivityIndicator(radius: 30),
//           );
//         } else if (state is GeolocationLoaded) {
//           return Stack(
//             children: [
//               GoogleMap(
//                 mapType: MapType.hybrid,
//                 initialCameraPosition: _kGooglePlex,
//                 zoomControlsEnabled: false,
//                 onMapCreated: (GoogleMapController controller) {
//                   _controller.complete(controller);
//                 },
//               ),
//               Column(
//                 children: [
//                   SizedBox(height: kTextTabBarHeight + Get.height * 0.05),
//                   LocationSearchBox(),
//                   SizedBox(height: 20),
//                   BlocBuilder<AutoCompleteBloc, AutocompleteState>(
//                       builder: (context, state) {
//                     if (state is AutoCompleteLoading) {
//                       return Center(
//                         child: CupertinoActivityIndicator(radius: 25),
//                       );
//                     } else if (state is AutoCompleteLoaded) {
//                       return Container(
//                         height: 300,
//                         width: Get.width / 1.5,
//                         color: state.placeAutoComplete.isNotEmpty
//                             ? Colors.black.withOpacity(0.6)
//                             : Colors.transparent,
//                         child: ListView.builder(
//                             itemCount: state.placeAutoComplete.length,
//                             itemBuilder: (context, i) {
//                               return ListTile(
//                                 title: Text(
//                                   state.placeAutoComplete[i].description,
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               );
//                             }),
//                       );
//                     } else {
//                       return Center(child: Text('Some thing wrong.'));
//                     }
//                   }),
//                   Spacer(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 18.0, horizontal: 15),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         RaisedButton(onPressed: () {}, child: Text('Save')),
//                         FloatingActionButton(
//                           onPressed: _goToTheLake,
//                           child: Icon(Icons.location_on_outlined),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           );
//         } else {
//           return Center(child: Text('Something went wrong'));
//         }
//       }),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     await _determinePosition();
//     final CameraPosition _kLake = CameraPosition(
//         bearing: 192.8334901395799,
//         target: LatLng(curPosition!.latitude, curPosition!.longitude),
//         tilt: 59.440717697143555,
//         zoom: 19.151926040649414);
//     if (curPosition != null) {
//       controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//     }
//   }
//
//   Future<Position?> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Fluttertoast.showToast(msg: 'Location services are disabled');
//       permission = await Geolocator.checkPermission();
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     curPosition = await Geolocator.getCurrentPosition();
//     return curPosition;
//   }
// }
//
// class LocationSearchBox extends StatelessWidget {
//   const LocationSearchBox({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AutoCompleteBloc, AutocompleteState>(
//         builder: (context, state) {
//       if (state is AutoCompleteLoading) {
//         return Center(
//           child: CupertinoActivityIndicator(radius: 25),
//         );
//       } else if (state is AutoCompleteLoaded) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: Get.width / 1.5,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: Colors.white,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(0.0),
//                 child: Column(
//                   children: [
//                     TextFormField(
//                         decoration: InputDecoration(
//                             hintText: 'Enter Your Location',
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 13, vertical: 15),
//                             border: InputBorder.none,
//                             suffixIcon: InkWell(
//                                 onTap: () {}, child: Icon(Icons.search))),
//                         onChanged: (val) {
//                           // print(val);
//                           context
//                               .read<AutoCompleteBloc>()
//                               .add(LoadAutoComplete(searchInput: val));
//                         }),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       } else {
//         return Center(child: Text('Some thing wrong.'));
//       }
//     });
//   }
// }
