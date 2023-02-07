import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_webservice/places.dart';


class navigationPage extends StatefulWidget {
  const navigationPage({Key? key}) : super(key: key);

  @override
  State<navigationPage> createState() => navigationPageState();
}

const kgoogleApiKey = "AIzaSyDFWger-QR2d_TxGy-nHAMjtuwUabmdzEo";
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class navigationPageState extends State<navigationPage> {

  Set<Marker> markersList = {};

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(39.480029, 29.899298);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  final TextEditingController search = TextEditingController();
  final Mode _mode = Mode.overlay;

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        kgoogleApiKey,
        PointLatLng(markersList.elementAt(0).position.latitude, markersList.elementAt(0).position.longitude),
        PointLatLng(markersList.elementAt(1).position.latitude, markersList.elementAt(1).position.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {

      });
    }
  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
     appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0),
        title: CupertinoSearchTextField(
          placeholder: "Arama",
          onTap: _handlePressButton,
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        polylines: {
          Polyline(polylineId: PolylineId("route"),
          points: polylineCoordinates,
            color: Colors.blueAccent,
            width: 6
          ),
        },
        markers: markersList,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 17.0,
        ),
      ),
    );
  }
  Future<void> _handlePressButton() async {

      Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kgoogleApiKey,
      onError: onError,
      mode: _mode,
      language: 'tr',
      strictbounds: false,
      types: [""],
      decoration: const InputDecoration(hintText: "Arama"),
      components: [Component(Component.country,"tr")]
    );

    displayPrediction(p!, homeScaffoldKey.currentState);
  }
  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState!.showSnackBar(SnackBar(content:Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {

    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kgoogleApiKey,
      apiHeaders:  await const GoogleApiHeaders().getHeaders()
    );
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    markersList.clear();
    userLocation(currentState);
    markersList.add(Marker(markerId: const MarkerId("Target"), position: LatLng(lat, lng), infoWindow: InfoWindow( title: detail.result.name)));

    setState(() {});

    mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 17.0));
  }
  Future<void> userLocation(ScaffoldState? currentState) async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    markersList.add(Marker(markerId: const MarkerId("userLocation"), position: location, infoWindow: const InfoWindow(title: "Başlangıç noktası")));
  }
}

