import 'package:submission3_restaurant_app/data/model/item.dart';

class Menu {
  Menu({
    this.foods,
    this.drinks,
  });

  List<Item>? foods;
  List<Item>? drinks;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        foods: List<Item>.from(json["foods"].map((x) => Item.fromJson(x))),
        drinks: List<Item>.from(json["drinks"].map((x) => Item.fromJson(x))),
      );
}
