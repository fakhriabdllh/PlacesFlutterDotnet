import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceNameController extends StateNotifier<TextEditingController> {
  PlaceNameController() : super(TextEditingController());

  String get text => state.text;
  void clear() {
    state.clear();
  }
}

final placeNameControllerProvider =
    StateNotifierProvider<PlaceNameController, TextEditingController>(
  (ref) => PlaceNameController(),
);

class OwnerNameController extends StateNotifier<TextEditingController> {
  OwnerNameController() : super(TextEditingController());

  String get text => state.text;
  void clear() {
    state.clear();
  }
}

final ownerNameControllerProvider =
    StateNotifierProvider<OwnerNameController, TextEditingController>(
  (ref) => OwnerNameController(),
);

class AddressController extends StateNotifier<TextEditingController> {
  AddressController() : super(TextEditingController());

  String get text => state.text;
  void clear() {
    state.clear();
  }
}

final addressControllerProvider =
    StateNotifierProvider<AddressController, TextEditingController>(
  (ref) => AddressController(),
);

class PlaceTypeController extends StateNotifier<TextEditingController> {
  PlaceTypeController() : super(TextEditingController());

  String get text => state.text;
  void clear() {
    state.clear();
  }
}

final placeTypeControllerProvider =
    StateNotifierProvider<PlaceTypeController, TextEditingController>(
  (ref) => PlaceTypeController(),
);

class ImageUrlController extends StateNotifier<TextEditingController> {
  ImageUrlController() : super(TextEditingController());

  String get text => state.text;
  void clear() {
    state.clear();
  }
}

final imageUrlControllerProvider =
    StateNotifierProvider<ImageUrlController, TextEditingController>(
  (ref) => ImageUrlController(),
);
