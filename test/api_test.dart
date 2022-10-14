import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission3_restaurant_app/data/api/api_service.dart';
import 'package:submission3_restaurant_app/data/model/detail_restaurant.dart';
import 'package:submission3_restaurant_app/data/model/list_restaurant.dart';
import 'package:submission3_restaurant_app/data/model/search_restaurant.dart';

import 'api_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group("fetchAllRestaurants", () {
    test('returns list of restaurant', () async {
      final client = MockClient();
      when(client.get(Uri.parse("https://restaurant-api.dicoding.dev/list")))
          .thenAnswer((_) async => http.Response(
              '{"error": false,"message": "success","count": 20,"restaurants": [ {"id": "rqdv5juczeskfw1e867","name": "Melting Pot","description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...","pictureId": "14","city": "Medan","rating": 4.2}, {"id": "s1knt6za9kkfw1e867","name": "Kafe Kita","description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...", "pictureId": "25","city": "Gorontalo","rating": 4}]}',
              200));

      expect(await ApiService().getRestaurants(client),
          const TypeMatcher<Result>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().getRestaurants(client), throwsException);
    });
  });

  group("fetchRestaurant", () {
    test('returns detail of a restaurant by id', () async {
      final client = MockClient();
      when(client.get(Uri.parse(
              "https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867")))
          .thenAnswer((_) async => http.Response(
              '{"error": false,"message": "success","restaurant": {"id": "rqdv5juczeskfw1e867","name": "Melting Pot", "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...","city": "Medan","address": "Jln. Pandeglang no 19","pictureId": "14","categories": [{"name": "Italia" },{ "name": "Modern"} ],"menus": {"foods": [{"name": "Paket rosemary"},{"name": "Toastie salmon"}],"drinks": [{"name": "Es krim" },{"name": "Sirup"}]},"rating": 4.2,"customerReviews": [{"name": "Ahmad","review": "Tidak rekomendasi untuk pelajar!","date": "13 November 2019"}]}}',
              200));

      expect(await ApiService().getRestaurant(client, "rqdv5juczeskfw1e867"),
          const TypeMatcher<DetailRestaurant>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      when(client.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().getRestaurant(client, "rqdv5juczeskfw1e867"),
          throwsException);
    });
  });

  group("searchRestaurant", () {
    test('returns detail of a restaurant search by query', () async {
      final client = MockClient();
      when(client.get(Uri.parse(
              "https://restaurant-api.dicoding.dev/search?q=makan%20mudah")))
          .thenAnswer((_) async => http.Response(
              '{"error":false,"founded":1,"restaurants":[{"id":"fnfn8mytkpmkfw1e867","name":"Makan mudah","description":"But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure.","pictureId":"22","city":"Medan","rating":3.7}]}',
              200));

      expect(await ApiService().searchRestaurants(client, "makan mudah"),
          const TypeMatcher<SearchResult>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      when(client.get(Uri.parse(
              "https://restaurant-api.dicoding.dev/search?q=makan%20mudah")))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(ApiService().searchRestaurants(client, "makan mudah"),
          throwsException);
    });
  });
}
