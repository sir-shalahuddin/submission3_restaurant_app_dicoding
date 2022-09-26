import 'dart:async';

import 'package:flutter/material.dart';
import 'package:submission2_restaurant_app/data/api/api_service.dart';
import 'package:submission2_restaurant_app/data/model/customer_review.dart';
import 'package:submission2_restaurant_app/data/model/detail_restaurant.dart';
import 'package:submission2_restaurant_app/provider/restaurants_provider.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  List<CustomerReview> _customerReviewsList = [];
  bool _isShow = false;
  DetailRestaurant? _result;
  late ResultState _state;
  String _message = '';

  RestaurantProvider({required this.apiService, required this.id}) {
    _fetchRestaurant(id).then((value) => {
          if (value.runtimeType != String)
            setCustomerReviews(value.restaurant.customerReviews)
        });
  }

  String get message => _message;

  DetailRestaurant? get result => _result;

  ResultState get state => _state;

  bool get isShow => _isShow;

  List<CustomerReview> get customerReviewsList => _customerReviewsList;

  void setIsShow(bool value) {
    _isShow = value;
    notifyListeners();
  }

  void setCustomerReviews(dynamic value) {
    _customerReviewsList = value;
    notifyListeners();
  }

  Future<dynamic> _fetchRestaurant(id) async {
    try {
      _state = ResultState.loading;

      notifyListeners();
      final data = await apiService.getRestaurant(id);
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
