// ignore_for_file: unnecessary_new, prefer_const_constructors, avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:venues_coin/models/coin_veneus_models.dart';
import 'package:http/http.dart' as http;

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  List<Venues> _coinVenues = [];
  GoogleMapController? _controller;
  List<Marker> markerList = [];
  CameraPosition? _initalCameraPosition;

  Set<Marker> _cretaeMarker() {
    markerList.add(
      new Marker(
          draggable: true,
          infoWindow: InfoWindow(title: 'Benim Konumum', onTap: () {}),
          markerId: MarkerId('aaee'),
          position: _initalCameraPosition!.target,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta)),
    );
    _coinVenues.forEach((resp) {
      return markerList.add(
        new Marker(
          draggable: true,
          infoWindow: InfoWindow(
              title: resp.name.toString(),
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      color: Color(0xFFED5460),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${resp.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          ListTile(
                            leading: Container(
                                width: 200,
                                height: 200,
                                child: Image.asset("bitcoin.jpg",
                                    width: 200, height: 200)),
                            title: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.category, color: Colors.white60),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      resp.category.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.timer_outlined,
                                        color: Colors.white60),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      DateFormat('dd.MM.yyyy').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              resp.createdOn! * 1000)),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    );
                  },
                );
              }),
          markerId: MarkerId(resp.id.toString()),
          position: LatLng(double.parse(resp.lat.toString()),
              double.parse(resp.lon.toString())),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    });

    return markerList.toSet();
  }

  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  @override
  void initState() {
    super.initState();
    getLocation().then((location) {
      getCoinVenues().then((res) {
        setState(() {
          _coinVenues = res;
        });
        setState(() {
          _initalCameraPosition = CameraPosition(
              target: LatLng(location.latitude, location.longitude), zoom: 15);
          _cretaeMarker();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initalCameraPosition != null
          ? GoogleMap(
              zoomControlsEnabled: true,
              trafficEnabled: true,
              markers: _cretaeMarker(),
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _initalCameraPosition!,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            )
          : Center(
              child: CircularProgressIndicator(
              color: Colors.green,
            )),
    );
  }

  Future<List<Venues>> getCoinVenues() async {
    var url = Uri.parse('https://coinmap.org/api/v1/venues/');
    var response = await http.get(url);
    var jsonMap = CoinVenues.fromJson(jsonDecode(response.body));
    return jsonMap.venues as List<Venues>;
  }
}
