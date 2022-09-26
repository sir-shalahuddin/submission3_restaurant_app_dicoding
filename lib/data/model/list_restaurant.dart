// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

class ListRestaurant {
  ListRestaurant({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  factory ListRestaurant.fromJson(Map<String, dynamic> json) => ListRestaurant(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<Restaurant>.from((json["restaurants"] as List)
            .map((x) => Restaurant.fromJson(x))
            .where((restaurant) =>
                restaurant.city != null &&
                restaurant.description != null &&
                restaurant.rating != null &&
                restaurant.name != null &&
                restaurant.pictureId != null)),
      );
}

class Restaurant {
  Restaurant({
    required this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.rating,
  });

  String id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  double? rating;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
      );
}

List<Restaurant> parseRestaurants(String? json) {
  if (json == null) {
    return [];
  }
  final List parsed = jsonDecode(json)['restaurants'];
  return parsed.map((json) => Restaurant.fromJson(json)).toList();
}
