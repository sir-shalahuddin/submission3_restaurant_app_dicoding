import 'package:flutter_test/flutter_test.dart';
import 'package:submission3_restaurant_app/data/model/add_review.dart';
import 'package:submission3_restaurant_app/data/model/customer_review.dart';
import 'package:submission3_restaurant_app/data/model/detail_restaurant.dart';
import 'package:submission3_restaurant_app/data/model/item.dart';
import 'package:submission3_restaurant_app/data/model/list_restaurant.dart';
import 'package:submission3_restaurant_app/data/model/menu.dart';
import 'package:submission3_restaurant_app/data/model/restaurant.dart';
import 'package:submission3_restaurant_app/data/model/search_restaurant.dart';

void main() {
  group("json_parsing_test", () {
    test("test parsing json item", () {
      final json = {"name": "Toastie salmon"};

      final result = Item.fromJson(json);
      expect(result.name, "Toastie salmon");
    });

    test("test parsing menu", () {
      final json = {
        "foods": [
          {"name": "Paket rosemary"},
          {"name": "Toastie salmon"}
        ],
        "drinks": [
          {"name": "Es krim"},
          {"name": "Sirup"}
        ]
      };

      final result = Menu.fromJson(json);
      expect(result.drinks, const TypeMatcher<List<Item>>());
      expect(result.foods, const TypeMatcher<List<Item>>());
    });

    test("test parsing Restaurant", () {
      final json = {
        "id": "rqdv5juczeskfw1e867",
        "name": "Melting Pot",
        "description":
            "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
        "city": "Medan",
        "address": "Jln. Pandeglang no 19",
        "pictureId": "14",
        "categories": [
          {"name": "Italia"},
          {"name": "Modern"}
        ],
        "menus": {
          "foods": [
            {"name": "Paket rosemary"},
            {"name": "Toastie salmon"}
          ],
          "drinks": [
            {"name": "Es krim"},
            {"name": "Sirup"}
          ]
        },
        "rating": 4.2,
        "customerReviews": [
          {
            "name": "Ahmad",
            "review": "Tidak rekomendasi untuk pelajar!",
            "date": "13 November 2019"
          }
        ]
      };

      final result = Restaurant.fromJson(json);
      expect(result.id, "rqdv5juczeskfw1e867");
      expect(result.name, "Melting Pot");
      expect(result.description,
          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...");
      expect(result.city, "Medan");
      expect(result.address, "Jln. Pandeglang no 19");
      expect(result.pictureId, "14");
      expect(result.categories, const TypeMatcher<List<Item>>());
      expect(result.menus, const TypeMatcher<Menu>());
      expect(result.rating, 4.2);
      expect(result.customerReviews, const TypeMatcher<List<CustomerReview>>());
    });

    test("test parsing customer review", () {
      final json = {
        "name": "Ahmad",
        "review": "Tidak rekomendasi untuk pelajar!",
        "date": "13 November 2019"
      };

      final result = CustomerReview.fromJson(json);
      expect(result.name, "Ahmad");
      expect(result.review, "Tidak rekomendasi untuk pelajar!");
      expect(result.date, "13 November 2019");
    });

    test("test parsing response 'https://restaurant-api.dicoding.dev/list'",
        () {
      final listRestaurant = {
        "error": false,
        "message": "success",
        "count": 20,
        "restaurants": [
          {
            "id": "rqdv5juczeskfw1e867",
            "name": "Melting Pot",
            "description":
                "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
            "pictureId": "14",
            "city": "Medan",
            "rating": 4.2
          },
          {
            "id": "s1knt6za9kkfw1e867",
            "name": "Kafe Kita",
            "description":
                "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
            "pictureId": "25",
            "city": "Gorontalo",
            "rating": 4
          }
        ]
      };

      final result = Result.fromJson(listRestaurant);

      expect(result.error, false);
      expect(result.message, "success");
      expect(result.count, 20);
      expect(result.restaurants, const TypeMatcher<List<Restaurant>>());
    });

    test(
        "test parsing response 'https://restaurant-api.dicoding.dev/detail/:id'",
        () {
      final json = {
        "error": false,
        "message": "success",
        "restaurant": {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description":
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
          "city": "Medan",
          "address": "Jln. Pandeglang no 19",
          "pictureId": "14",
          "categories": [
            {"name": "Italia"},
            {"name": "Modern"}
          ],
          "menus": {
            "foods": [
              {"name": "Paket rosemary"},
              {"name": "Toastie salmon"}
            ],
            "drinks": [
              {"name": "Es krim"},
              {"name": "Sirup"}
            ]
          },
          "rating": 4.2,
          "customerReviews": [
            {
              "name": "Ahmad",
              "review": "Tidak rekomendasi untuk pelajar!",
              "date": "13 November 2019"
            }
          ]
        }
      };

      final result = DetailRestaurant.fromJson(json);
      expect(result.error, false);
      expect(result.message, "success");
      expect(result.restaurant, const TypeMatcher<Restaurant>());
    });

    test(
        "test parsing response 'https://restaurant-api.dicoding.dev/search?q=query'",
        () {
      final json = {
        "error": false,
        "founded": 1,
        "restaurants": [
          {
            "id": "fnfn8mytkpmkfw1e867",
            "name": "Makan mudah",
            "description":
                "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, ...",
            "pictureId": "22",
            "city": "Medan",
            "rating": 3.7
          }
        ]
      };

      final result = SearchResult.fromJson(json);

      expect(result.error, false);
      expect(result.founded, 1);
      expect(result.restaurants, const TypeMatcher<List<Restaurant>>());
    });
    test("test parsing response 'httos://restaurant-api.dicoding.dev/review",
        () {
      final json = {
        "error": false,
        "message": "success",
        "customerReviews": [
          {
            "name": "Ahmad",
            "review": "Tidak rekomendasi untuk pelajar!",
            "date": "13 November 2019"
          },
          {
            "name": "test",
            "review": "makanannya lezat",
            "date": "29 Oktober 2020"
          }
        ]
      };

      final result = PostReviewResult.fromJson(json);
      expect(result.error, false);
      expect(result.message, "success");
      expect(result.customerReviews, const TypeMatcher<List<CustomerReview>>());
    });
  });
}
