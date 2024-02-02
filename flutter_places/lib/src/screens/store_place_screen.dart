// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_places/src/data/data_provider.dart';
import 'package:flutter_places/src/data/input_text_provider.dart';
import 'package:flutter_places/src/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class StorePlaceScreen extends ConsumerStatefulWidget {
  const StorePlaceScreen({Key? key}) : super(key: key);

  @override
  _StorePlaceScreenState createState() => _StorePlaceScreenState();
}

class _StorePlaceScreenState extends ConsumerState<StorePlaceScreen> {
  @override
  Widget build(BuildContext context) {
    final placeNameCont = ref.watch(placeNameControllerProvider.notifier);
    final ownerNameCont = ref.watch(ownerNameControllerProvider.notifier);
    final addressCont = ref.watch(addressControllerProvider.notifier);
    final placeTypeCont = ref.watch(placeTypeControllerProvider.notifier);
    final imageUrlCont = ref.watch(imageUrlControllerProvider.notifier);
    final size = MediaQuery.of(context).size;

    const selectedLocation = LatLng(-6.239099119703604, 106.76310133701345);

    final mapCont = ref.watch(mapControllerProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store Place',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              'Enter information about this place',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _inputForm(size, placeNameCont.state, "Place Name"),
                _inputForm(size, ownerNameCont.state, "Owner Name"),
                _inputForm(size, addressCont.state, "Address"),
                _inputForm(size, placeTypeCont.state, "Place Type"),
                _inputForm(size, imageUrlCont.state, "Image Url"),
                _widgetMap(mapCont, selectedLocation),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      _widgetButton(() => Navigator.pop(context), Colors.blue,
                          Colors.white, 'Cancel'),
                      const SizedBox(width: 8),
                      _widgetButton(
                          () => onSendTap(
                              ref,
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                                (route) => false,
                              )),
                          Colors.white,
                          Colors.blue,
                          'Send'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputForm(Size size, TextEditingController controller, String hint) {
    return Container(
      width: size.width,
      height: 50,
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[350]!,
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: TextField(
        style: const TextStyle(fontSize: 12),
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
          border: InputBorder.none,
          hintText: hint,
          label: Text(hint, style: const TextStyle(fontSize: 12)),
          hintStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _widgetMap(MapController mapCont, LatLng location) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      height: 200,
      child: FlutterMap(
        mapController: mapCont,
        options: MapOptions(
          initialCenter: location,
          initialZoom: 15,
          onPositionChanged: (position, hasGesture) {
            mapCont.move(
              LatLng(position.center!.latitude, position.center!.longitude),
              mapCont.camera.zoom,
            );
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          RichAttributionWidget(attributions: [
            TextSourceAttribution('OpenStreetMap contributors', onTap: () {}),
          ]),
          Container(
            alignment: Alignment.center,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 12,
                  child: Text(
                    "Choose Pin Point",
                    style: TextStyle(fontSize: 10, color: Colors.red),
                  ),
                ),
                Icon(
                  Icons.place,
                  color: Colors.red,
                  size: 25,
                ),
                SizedBox(height: 37),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _widgetButton(onTap, primaryColor, secondaryColor, label) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: secondaryColor,
            border: Border.all(
              color: primaryColor,
              width: 0.5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: Text(
            label,
            style: TextStyle(
                color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }

  onSendTap(ref, navigate) async {
    try {
      final ownerName = ref.read(ownerNameControllerProvider.notifier);
      final placeName = ref.read(placeNameControllerProvider.notifier);
      final address = ref.read(addressControllerProvider.notifier);
      final placeType = ref.read(placeTypeControllerProvider.notifier);
      final imageUrl = ref.read(imageUrlControllerProvider.notifier);

      await ref.read(storePlaceProvider.future);

      ownerName.clear();
      placeName.clear();
      address.clear();
      placeType.clear();
      imageUrl.clear();

      navigate();
    } catch (e) {
      rethrow;
    }
  }
}
