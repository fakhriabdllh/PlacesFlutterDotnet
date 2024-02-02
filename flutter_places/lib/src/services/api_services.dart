import 'dart:convert';

import 'package:flutter_places/src/models/places_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

class ApiServices {
  String baseUrl = 'https://b2f9-182-253-56-133.ngrok-free.app/api/Places';

  Future<List<PlacesModel>> getPlaces() async {
    Response response = await get(Uri.parse("$baseUrl/Places"));

    if (response.statusCode == 200) {
      final List<dynamic> responseData =
          jsonDecode(response.body)['responseData'];
      final List<PlacesModel> result = responseData
          .map((e) => PlacesModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<PlacesModel> getPlacesById(int id) async {
    Response response = await get(Uri.parse("$baseUrl/Places/$id"));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)['responseData'];
      final PlacesModel result = PlacesModel.fromJson(responseData);
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<void> deletePlace(int id) async {
    Response response = await delete(Uri.parse("$baseUrl/Delete/$id"));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)['responseData'];
      return responseData;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<PlacesModel> createPlace(PlacesModel newPlace) async {
    Response response = await post(
      Uri.parse("$baseUrl/Store"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newPlace.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)['responseData'];
      final PlacesModel result = PlacesModel.fromJson(responseData);
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<PlacesModel> updatePlace(int id, PlacesModel updatedPlace) async {
    final Map<String, dynamic> requestBody = updatedPlace.toJson();

    try {
      Response response = await put(
        Uri.parse('$baseUrl/Update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['responseData'];
        final PlacesModel result = PlacesModel.fromJson(responseData);
        return result;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception('Error updating place: $e');
    }
  }
}

final placesProvider = Provider<ApiServices>((ref) => ApiServices());
