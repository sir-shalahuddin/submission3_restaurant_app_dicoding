import 'dart:async';

import 'package:flutter/material.dart';
import 'package:submission2_restaurant_app/data/api/api_service.dart';
import 'package:submission2_restaurant_app/data/model/list_restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantsProvider extends ChangeNotifier {
  final ApiService apiService;


  RestaurantsProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  late Result _result;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  Result get result => _result;

  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {

      _state = ResultState.loading;

      notifyListeners();
      final data = await apiService.getRestaurants();
      if (data.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _result = data;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}