import 'package:submission2_restaurant_app/data/model/restaurant.dart';

class SearchResult {
  SearchResult(
      {required this.error, required this.restaurants, required this.founded});

  bool error;
  int founded;
  List<Restaurant> restaurants;

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(
            (json["restaurants"]).map((x) => Restaurant.fromJson(x))),
      );
}
