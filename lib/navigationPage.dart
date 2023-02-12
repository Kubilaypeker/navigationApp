import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:provider/provider.dart';
import 'authenticationService.dart';
import 'main.dart';

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
  final places = GoogleMapsPlaces(apiKey: "AIzaSyDFWger-QR2d_TxGy-nHAMjtuwUabmdzEo");

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  final TextEditingController search = TextEditingController();
  final Mode _mode = Mode.overlay;

  List<LatLng> polylineCoordinates = [];

  MapsRoutes route = new MapsRoutes();
  DistanceCalculator distanceCalculator = new DistanceCalculator();
  String totalDistance = 'No route';

  @override
  void initState() {
    getUserLocation(homeScaffoldKey.currentState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
     appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color(0xff282828),
        title: const Text("DPÜ NAVİGASYON",
        style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff1558BE)
        ),
        ),
       actions: <IconButton>[
         IconButton(onPressed: _handlePressButton,
             icon: const Icon(Icons.search)),
       IconButton(onPressed: () {
         context.read<AuthenticationService>().signOut();
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => AuthenticationWrapper(),
           ),
         );
       },
           icon:const Icon(Icons.logout))
       ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        trafficEnabled: false,
        myLocationEnabled: true,
        polylines: route.routes,
        markers: markersList,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 17.0,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff282828),
        items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: IconButton(icon: const Icon(Icons.restaurant,), onPressed: () => dpuRestaurants()), label: ""),
          BottomNavigationBarItem(icon: IconButton(icon: const Icon(Icons.directions_bus,), onPressed: () => dpuBusStations()), label: ""),
          BottomNavigationBarItem(icon: IconButton(icon: const Icon(Icons.apartment,), onPressed: () => dpuBuildings()), label: ""),
      ],
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
      decoration: const InputDecoration(hintText: "Nereye gitmek istiyorsunuz?"),
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
    getUserLocation(currentState);
    markersList.add(Marker(markerId: const MarkerId("1"), position: LatLng(lat, lng), infoWindow: InfoWindow( title: detail.result.name)));
    getNavigate();
    setState(() {
    });

    mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 17.0));
  }
  Future<void> getUserLocation(ScaffoldState? currentState) async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {

    });
    markersList.add(Marker(markerId: const MarkerId("0"), position: location, infoWindow: const InfoWindow(title: "Kullanıcı konumu")));
    getNavigate();
  }

  Future<void> dpuRestaurants() async {
    PlacesSearchResponse response = await places.searchNearbyWithRadius(
        Location(lat: 39.480029,lng: 29.899298), 10000,
        type: "restaurant");

    PlacesSearchResponse response2 = await places.searchNearbyWithRadius(
        Location(lat: 39.480029,lng: 29.899298), 10000,
        keyword: "kafe");

    PlacesSearchResponse response3 = await places.searchNearbyWithRadius(
        Location(lat: 39.480029,lng: 29.899298), 10000,
        keyword: "cafe");

    PlacesSearchResponse response4 = await places.searchNearbyWithRadius(
        Location(lat: 39.480029,lng: 29.899298), 10000,
        keyword: "yemekhane");

    PlacesSearchResponse response5 = await places.searchNearbyWithRadius(
        Location(lat: 39.480029,lng: 29.899298), 10000,
        keyword: "kafeterya");

    Set < Marker > restaurantMarkers = (response.results + response2.results+ response3.results + response4.results + response5.results)
        .map((result) => Marker(
        markerId: MarkerId(result.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
            title: result.name,
            ),
        position: LatLng(
            result.geometry!.location.lat, result.geometry!.location.lng)))
        .toSet();

    setState(() {
      markersList.clear();
      getUserLocation(homeScaffoldKey.currentState);
      markersList.addAll(restaurantMarkers);
      mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(39.480029,29.899298), 17.0));
    });
  }

  Future<void> dpuBusStations() async {
    PlacesSearchResponse response = await places.searchNearbyWithRadius(
        Location(lat: 39.480029,lng: 29.899298), 10000,
        type: "transit_station");



    Set <Marker> busStationMarkers = response.results
        .map((result) => Marker(
        markerId: MarkerId(result.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: result.name,
        ),

        position: LatLng(
            result.geometry!.location.lat, result.geometry!.location.lng)))
        .toSet();

    setState(() {
      markersList.clear();
      getUserLocation(homeScaffoldKey.currentState);
      markersList.addAll(busStationMarkers);
      mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(39.480029,29.899298), 17.0));
    });
  }

  Future<void> dpuBuildings() async {
    PlacesSearchResponse response = await places.searchNearbyWithRadius(
        Location(lat: 39.480029,lng: 29.899298), 10000,
        keyword: "DPÜ");
    Set <Marker> busStationMarkers = response.results
        .map((result) => Marker(
        markerId: MarkerId(result.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: result.name,
        ),

        position: LatLng(
            result.geometry!.location.lat, result.geometry!.location.lng)))
        .toSet();

    setState(() {
      markersList.clear();
      markersList.addAll(busStationMarkers);
      mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(39.480029, 29.899298), 17.0));
    });
  }

  Future<void> getNavigate() async {
    await route.drawRoute([markersList.elementAt(0).position, markersList.elementAt(1).position], 'Test routes',
        const Color(0xff1558BE), kgoogleApiKey,
        travelMode: TravelModes.walking);
    setState(() {
      totalDistance =
          distanceCalculator.calculateRouteDistance(
              [
                LatLng(markersList.elementAt(0).position.latitude, markersList.elementAt(0).position.longitude),
                LatLng(markersList.elementAt(1).position.latitude, markersList.elementAt(1).position.longitude)
              ],
              decimals: 1);
          }
          );
  }
}

