import 'package:submission3_restaurant_app/data/model/restaurant.dart';

class Result {
  Result({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  bool error;
  String message;
  int count;
  List<Restaurant> restaurants;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        error: json["error"],
        message: json["message"],
        count: json["count"],
        restaurants: List<Restaurant>.from(
            (json["restaurants"]).map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "count": count,
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };
}
