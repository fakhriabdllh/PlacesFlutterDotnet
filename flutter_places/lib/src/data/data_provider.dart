import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_places/src/data/input_text_provider.dart';
import 'package:flutter_places/src/models/places_model.dart';
import 'package:flutter_places/src/services/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getPlacesDataProvider = FutureProvider.autoDispose<List<PlacesModel>>(
  (ref) async {
    return ref.watch(placesProvider).getPlaces();
  },
);

final getPlacesDataProviderById =
    FutureProvider.autoDispose.family<PlacesModel, int>(
  (ref, id) async {
    final x = ref.watch(placesProvider);
    final placesDetail = await x.getPlacesById(id);
    return placesDetail;
  },
);

final storePlaceProvider = FutureProvider.autoDispose<PlacesModel>((ref) async {
  final ownerName = ref.read(ownerNameControllerProvider);
  final placeName = ref.read(placeNameControllerProvider);
  final address = ref.read(addressControllerProvider);
  final longitude = ref.read(mapControllerProvider);
  final latitude = ref.read(mapControllerProvider);
  final placeType = ref.read(placeTypeControllerProvider);
  final imageUrl = ref.read(imageUrlControllerProvider);

  final newPlace = PlacesModel(
    id: 0,
    ownerName: ownerName.text,
    placeName: placeName.text,
    address: address.text,
    longitude: longitude.camera.center.longitude.toString(),
    latitude: latitude.camera.center.latitude.toString(),
    placeType: placeType.text,
    imageUrl: imageUrl.text,
    inputDate: DateTime.now().toString(),
  );

  return ref.watch(placesProvider).createPlace(newPlace);
});

final updatePlaceProvider =
    AutoDisposeFutureProviderFamily<void, int>((ref, id) async {
  final ownerName = ref.read(ownerNameControllerProvider.notifier);
  final placeName = ref.read(placeNameControllerProvider.notifier);
  final address = ref.read(addressControllerProvider.notifier);
  final longitude = ref.read(mapControllerProvider);
  final latitude = ref.read(mapControllerProvider);
  final placeType = ref.read(placeTypeControllerProvider.notifier);
  final imageUrl = ref.read(imageUrlControllerProvider.notifier);

  final updatedPlace = PlacesModel(
    id: id,
    ownerName: ownerName.text,
    placeName: placeName.text,
    address: address.text,
    longitude: longitude.camera.center.longitude.toString(),
    latitude: latitude.camera.center.latitude.toString(),
    placeType: placeType.text,
    imageUrl: imageUrl.text,
    inputDate: DateTime.now().toString(),
  );

  await ref.read(placesProvider).updatePlace(id, updatedPlace);
});

final deletePlaceProvider =
    FutureProvider.autoDispose.family<void, int>((ref, id) async {
  await ref.watch(placesProvider).deletePlace(id);
});

final mapControllerProvider = Provider.autoDispose<MapController>((ref) {
  return MapController();
});
