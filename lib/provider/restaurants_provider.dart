import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:submission3_restaurant_app/data/api/api_service.dart';
import 'package:submission3_restaurant_app/data/model/list_restaurant.dart';
import 'package:submission3_restaurant_app/data/model/restaurant.dart';
import 'package:submission3_restaurant_app/data/model/search_restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantsProvider extends ChangeNotifier {
  final ApiService apiService;
  List<Restaurant> _restaurantsList = [];
  late Result _result;
  late SearchResult _searchResult;
  late ResultState _state;
  String _message = '';

  RestaurantsProvider({required this.apiService}) {
    _fetchAllRestaurant().then((value) =>
        {if (value.runtimeType != String) setRestaurant(value.restaurants)});
  }

  List<Restaurant> get restaurantList => _restaurantsList;

  String get message => _message;

  Result get result => _result;

  SearchResult get searchResult => _searchResult;

  ResultState get state => _state;

  void setRestaurant(List<Restaurant> value) {
    _restaurantsList = value;
    notifyListeners();
  }

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;

      notifyListeners();
      final data = await apiService.getRestaurants(http.Client());
      if (data.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Restaurant not found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _result = data;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e.toString() == "Failed host lookup: 'restaurant-api.dicoding.dev'") {
        return _message = "Check Your Internet Connection";
      }
      return _message = "Error-> $e";
    }
  }

  void searchRestaurant(String query) async {
    _searchRestaurant(query).then((value) =>
        {if (value.runtimeType != String) setRestaurant(value.restaurants)});
  }

  Future<dynamic> _searchRestaurant(String query) async {
    try {
      _state = ResultState.loading;

      notifyListeners();
      final data = await apiService.searchRestaurants(http.Client(), query);
      if (data.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Restaurant not found';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchResult = data;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e.toString() == "Failed host lookup: 'restaurant-api.dicoding.dev'") {
        return _message = "Check Your Internet Connection";
      }
      return _message = "Error-> $e";
    }
  }
}
