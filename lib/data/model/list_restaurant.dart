import 'package:submission2_restaurant_app/data/model/restaurant.dart';

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
}
