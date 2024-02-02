// user_model.dart

class PlacesModel {
  final int id;
  final String ownerName;
  final String placeName;
  final String address;
  final String longitude;
  final String latitude;
  final String placeType;
  final String imageUrl;
  final String inputDate;

  PlacesModel({
    this.id = 0,
    required this.ownerName,
    required this.placeName,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.placeType,
    required this.imageUrl,
    this.inputDate = '',
  });

  factory PlacesModel.fromJson(Map<String, dynamic> json) {
    return PlacesModel(
      id: json['id'] ?? '',
      ownerName: json['ownerName'] ?? '',
      placeName: json['placeName'] ?? '',
      address: json['address'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      placeType: json['placeType'] ?? '',
      imageUrl: json['image_url'] ?? '',
      inputDate: json['inputDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerName': ownerName,
      'placeName': placeName,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
      'placeType': placeType,
      'image_url': imageUrl,
    };
  }
}
