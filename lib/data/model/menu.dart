import 'package:submission2_restaurant_app/data/model/items.dart';

class Menus {
  Menus({
    this.foods,
    this.drinks,
  });

  List<Item>? foods;
  List<Item>? drinks;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
    foods: List<Item>.from(json["foods"].map((x) => Item.fromJson(x))),
    drinks: List<Item>.from(json["drinks"].map((x) => Item.fromJson(x))),
  );

}