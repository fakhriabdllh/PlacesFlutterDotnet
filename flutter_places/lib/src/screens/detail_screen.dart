import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_places/src/data/data_provider.dart';
import 'package:flutter_places/src/screens/home_screen.dart';
import 'package:flutter_places/src/screens/update_place_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DetailScreen extends ConsumerWidget {
  final int id;
  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, ref) {
    final data = ref.watch(getPlacesDataProviderById(id));
    var size = MediaQuery.of(context).size;
    var verticalPadding = const EdgeInsets.symmetric(vertical: 4);

    return Scaffold(
      body: data.when(
        data: (placesDetail) {
          LatLng selectedLocation = LatLng(double.parse(placesDetail.latitude),
              double.parse(placesDetail.longitude));
          List<Marker> getMarkers() {
            return [
              Marker(
                point: selectedLocation,
                child: const Icon(
                  Icons.place,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ];
          }

          return SafeArea(
            child: Stack(children: [
              _widgetMap(selectedLocation, getMarkers, size),
              _widgetDetail(size, verticalPadding, placesDetail, context, ref),
              _widgetBackButton(context),
            ]),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Colors.grey,
          ),
        ),
        error: (error, stackTrace) => Text(error.toString()),
      ),
    );
  }

  _widgetMap(location, Function() getMarkers, size) {
    return SizedBox(
      height: size.height / 2,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: location,
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          RichAttributionWidget(attributions: [
            TextSourceAttribution('OpenStreetMap contributors',
                onTap: () => {}),
          ]),
          MarkerLayer(markers: getMarkers()),
        ],
      ),
    );
  }

  _widgetDetail(size, verticalPadding, placesDetail, context, ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: size.height / 2,
        width: size.width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: verticalPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    placesDetail.placeName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdatePlacesScreen(
                                  id: id,
                                )),
                      )
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 18,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: verticalPadding,
              child: Row(
                children: [
                  Icon(
                    Icons.place,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      placesDetail.address,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: verticalPadding,
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      placesDetail.placeType,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: verticalPadding,
              child: Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      placesDetail.ownerName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => _deleteDialog(
                        context, placesDetail.placeName, placesDetail.id, ref),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.red[400],
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: size.width,
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: CachedNetworkImage(
                  imageUrl: placesDetail.imageUrl,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14))),
                      child: Icon(
                        Icons.error,
                        size: 30,
                        color: Colors.grey[400],
                      )),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _widgetBackButton(context) {
    return Align(
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(left: 6, top: 6),
          alignment: Alignment.center,
          width: 40,
          height: 40,
          padding: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
      ),
    );
  }

  _deleteDialog(context, name, id, ref) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text('Delete $name?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              var result = ref.watch(deletePlaceProvider(id));
              result;
              result.when(
                data: {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false,
                  )
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                ),
                error: (error, stackTrace) => Text(error.toString()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
