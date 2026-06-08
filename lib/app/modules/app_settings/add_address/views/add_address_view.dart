import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../data/models/Address/req_address.dart';
import '../controllers/add_address_controller.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({Key? key}) : super(key: key);

  @override
  State<AddAddressView> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddAddressView> {
  final TextEditingController addressController = TextEditingController();
  late GoogleMapController mapController;
  String _currentAddress = '';
  bool _isLocationSelected = false;
  final controller = Get.put(AddAddressController());
  late ReqAddress address;

  LatLng _currentPosition =
  const LatLng(11.562108, 104.888535); // Default: Phnom Penh

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
      }
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied.')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Location permissions are permanently denied.')),
        );
      }
      return;
    }

    // Get the current position
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLocationSelected = true;
      });

      // Move the map camera to the current location
      mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));

      // Fetch address from coordinates
      await _getAddressFromLatLng(
          _currentPosition.latitude, _currentPosition.longitude);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get current location: $e')),
        );
      }
    }
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}, ${place.postalCode}";
        addressController.text = _currentAddress;
      });

      // Build address object
      address = ReqAddress(
        line1: place.street ?? "",
        latitude: latitude,
        longitude: longitude,
        city: place.locality ?? "Phnom Penh",
        country: place.country ?? "",
        postalCode: 12000,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get address: $e')),
        );
      }
    }
  }

  // Called only when the camera stops moving (fixes the ocean coordinate bug)
  Future<void> _onCameraIdle() async {
    await _getAddressFromLatLng(
        _currentPosition.latitude, _currentPosition.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Address'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () {
              if (_isLocationSelected) {
                controller.addAddress(address);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please select a location first.')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Google Map
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 15,
                  ),
                  onMapCreated: (ctrl) {
                    mapController = ctrl;
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,

                  onCameraMove: (position) {
                    setState(() {
                      _currentPosition = position.target;
                      _isLocationSelected = true;
                    });
                  },

                  onCameraIdle: _onCameraIdle,
                ),
                const Center(
                  child: Icon(Icons.location_pin, size: 40, color: Colors.pink),
                ),
              ],
            ),
          ),

          // Address Input Field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: 'Enter your address',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    addressController.clear();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Illustration and Instructions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.network(
                  "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/google-map-icon.png",
                  height: 100,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Enter an address or move the pin to the correct location on the map.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0, color: Colors.black87),
                ),
              ],
            ),
          ),

          // "Use My Current Location" Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: _getCurrentLocation,
              child: const Text(
                'Use my current location',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}