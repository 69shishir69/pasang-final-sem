import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hospital_management_system/models/doctorModel.dart';
import 'package:hospital_management_system/repository/category_repository.dart';
// import 'package:location/location.dart';

class MyMapScreen extends StatefulWidget {
  const MyMapScreen({Key? key}) : super(key: key);

  @override
  State<MyMapScreen> createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapScreen> {
  GoogleMapController? mapController;

  final Set<Marker> _markers = {};
  LatLng myLocation = const LatLng(27.7047139, 85.3295421);

  BitmapDescriptor? markerImage;
  String searchsave = "";

  @override
  void initState() {
    getLocation();
    markericon();
    super.initState();
  }

  // Custom Marker Code
  void markericon() async {
    BitmapDescriptor? markerImage1 = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(50, 50)),
        'assets/images/location.png');
    setState(() {
      markerImage = markerImage1;
    });
  }

  // Google Map Controller
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // Get My Location Code
  void getLocation() async {
    Position? currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 14);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  void getNewLocation() async {
    // Position? currentPosition = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    CameraPosition cameraPosition =
        const CameraPosition(target: LatLng(58.5645464, 85.654541), zoom: 20);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  // Medicine Location
  void getMedicineLocation() async {
    Position? currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    CameraPosition cameraPosition = CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 14);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  // Search Bar Controller
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  int _medQuantity = 1;

  void _incrementCount() {
    setState(() {
      _medQuantity++;
    });
  }

  void _decrementCount() {
    setState(() {
      _medQuantity--;
    });
  }

  // // Book Medicine Controller
  // final _quantity = TextEditingController();
  // final _total_price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
      borderSide: BorderSide.none,
    );
    return Scaffold(
      body: FutureBuilder<List<DoctorModel?>>(
        future: CategoryRepository().loadAllDoctor(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              // ProductResponse productResponse = snapshot.data!;
              for (int i = 0; i < snapshot.data!.length; i++) {
                final String id = snapshot.data![i]!.id!;
                debugPrint("${snapshot.data![i]!.id!}Phjarmacy");
                _markers.add(
                  Marker(
                    markerId: MarkerId(snapshot.data![i].toString()),
                    position: LatLng(
                        snapshot.data![i]!.lat!, snapshot.data![i]!.lng!),
                    infoWindow: InfoWindow(
                      // onTap: () => showMaterialModalBottomSheet(
                      //   context: context,
                      //   builder: (context) {
                      //     return StatefulBuilder(builder: (BuildContext context,
                      //         StateSetter setStateSheet) {
                      //       return _showModalBottomSheet(setStateSheet,
                      //           id);
                      //     });
                      //   },
                      // ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/appointmentDoctorDetailsScreen',
                          arguments: [
                            id,
                            snapshot.data![i]!.price!,
                          ],
                        );
                      },
                      title: snapshot.data![i]!.fname!,
                      snippet:
                          'lat:${snapshot.data![i]!.lat!} lng:${snapshot.data![i]!.lng!}',
                    ),
                    icon: markerImage!,
                  ),
                );
              }
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: myLocation,
                  // zoom: 10,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              );
            } else {
              return const Center(
                child: Text("No data"),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }
        },
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.fromLTRB(0, 8, 80, 0),
      //   child: Form(
      //     key: _formKey,
      //     child: TextFormField(
      //       style: const TextStyle(
      //         fontWeight: FontWeight.bold,
      //         color: Color.fromARGB(255, 255, 255, 255),
      //         fontSize: 14,
      //         fontFamily: 'Merienda',
      //       ),
      //       controller: _searchController,
      //       decoration: InputDecoration(
      //         labelText: "Medicine or Pharmacy",
      //         labelStyle: const TextStyle(color: Color(0xFFFFFFFF)),
      //         filled: true,
      //         fillColor: const Color(0xFF6BB3ED),
      //         border: outlineInputBorder,
      //         enabledBorder: outlineInputBorder,
      //         focusedBorder: outlineInputBorder,
      //         prefixIcon: const Padding(
      //           padding: EdgeInsets.fromLTRB(14, 6, 14, 6),
      //           child: Iconify(
      //             Ep.search,
      //             color: Color(0xFFFFFFFF),
      //           ),
      //         ),
      //         suffixIcon: Padding(
      //           padding: const EdgeInsets.symmetric(
      //             horizontal: 12,
      //           ),
      //           child: SizedBox(
      //             height: 50,
      //             width: 50,
      //             child: ElevatedButton(
      //               onPressed: () {
      //                 setState(() {
      //                   Navigator.popAndPushNamed(context, "/nxtmap");
      //                 });
      //               },
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      //                 shape: const RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.all(
      //                     Radius.circular(12),
      //                   ),
      //                 ),
      //               ),
      //               child: const Iconify(
      //                 Ep.search,
      //                 size: 50,
      //                 color: Color(0xFF6BB3ED),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  Widget _showModalBottomSheet(StateSetter setStateSheet, String pharmacyId) {
    debugPrint("Pharmacy ID:$pharmacyId");
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
        child: Column(
          children: const [
            Text(
              "Medicines",
              style: TextStyle(
                color: Color(0xFF6BB3ED),
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Merienda',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
