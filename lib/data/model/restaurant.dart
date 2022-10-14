import 'package:submission3_restaurant_app/data/model/customer_review.dart';
import 'package:submission3_restaurant_app/data/model/item.dart';
import 'package:submission3_restaurant_app/data/model/menu.dart';

class Restaurant {
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    this.address,
    this.categories,
    this.menus,
    this.customerReviews,
  });

  String? id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  double? rating;
  String? address;
  List<Item>? categories;
  Menu? menus;
  List<CustomerReview>? customerReviews;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
        address: json["address"],
        categories: json["categories"] == null
            ? null
            : List<Item>.from(json["categories"].map((x) => Item.fromJson(x))),
        menus: json["menus"] == null ? null : Menu.fromJson(json["menus"]),
        customerReviews: json["customerReviews"] == null
            ? null
            : List<CustomerReview>.from(
                json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pictureId': pictureId,
      'city': city,
      'rating': rating,
      'address': address
    };
  }

  Restaurant.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    pictureId = map['pictureId'];
    city = map['city'];
    rating = map['rating'];
    address = map['address'];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating,
  };

}
