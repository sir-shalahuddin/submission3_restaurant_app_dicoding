import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:submission2_restaurant_app/data/model/add_review.dart';
import 'package:submission2_restaurant_app/data/model/detail_restaurant.dart';
import 'package:submission2_restaurant_app/data/model/list_restaurant.dart';
import 'package:submission2_restaurant_app/data/model/search_restaurant.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<Result> getRestaurants() async {
    final response = await http.get(Uri.parse("${_baseUrl}list"));
    if (response.statusCode == 200) {
      return Result.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load list restaurants');
    }
  }

  Future<DetailRestaurant> getRestaurant(String id) async {
    final response = await http.get(Uri.parse("${_baseUrl}detail/$id"));
    if (response.statusCode == 200) {
      return DetailRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load detail restaurant');
    }
  }

  Future<SearchResult> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse("${_baseUrl}search?q=$query"));
    if (response.statusCode == 200) {
      return SearchResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load list restaurant');
    }
  }

  Future<PostReviewResult> addReview(
      String id, String name, String review) async {
    final response = await http.post(
      Uri.parse("${_baseUrl}review"),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(
          <String, String>{"id": id, "name": name, "review": review}),
    );
    if (response.statusCode == 201) {
      return PostReviewResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to submit reviews');
    }
  }
}
