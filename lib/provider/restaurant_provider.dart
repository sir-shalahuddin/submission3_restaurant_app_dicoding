import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:submission3_restaurant_app/data/api/api_service.dart';
import 'package:submission3_restaurant_app/data/local_db/db_helper.dart';
import 'package:submission3_restaurant_app/data/model/detail_restaurant.dart';
import 'package:submission3_restaurant_app/data/model/restaurant.dart';
import 'package:submission3_restaurant_app/provider/restaurants_provider.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  Restaurant restaurant;
  //
  bool _isShow = false;
  bool _isFavourite = false;
  DetailRestaurant? _result;
  late ResultState _state;
  String _message = '';
  late DatabaseHelper _dbHelper;

  RestaurantProvider({required this.apiService, required this.restaurant}) {
    _fetchRestaurant(restaurant.id).then((value) =>
        {if (value.runtimeType != String) restaurant = value.restaurant});
    _dbHelper = DatabaseHelper();
    getRestaurantById(restaurant.id);
  }

  String get message => _message;

  DetailRestaurant? get result => _result;

  ResultState get state => _state;

  bool get isShow => _isShow;

  bool get isFavourite => _isFavourite;

  void setIsShow(bool value) {
    _isShow = value;
    notifyListeners();
  }

  void setIsFavourite(bool value) {
    _isFavourite = value;
    notifyListeners();
  }

  void getRestaurantById(id) {
    _dbHelper.getRestaurantById(id).then((value) => {
          value is! String ? setIsFavourite(true) : setIsFavourite(false),
        });
  }

  Future<dynamic> _fetchRestaurant(id) async {
    try {
      _state = ResultState.loading;

      notifyListeners();
      final data = await apiService.getRestaurant(http.Client(), id);
      _state = ResultState.hasData;
      notifyListeners();
      return _result = data;
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
