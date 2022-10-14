import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:submission3_restaurant_app/data/api/api_service.dart';
import 'package:submission3_restaurant_app/data/model/add_review.dart';
import 'package:submission3_restaurant_app/data/model/customer_review.dart';
import 'package:submission3_restaurant_app/provider/restaurants_provider.dart';

class CustomerReviewsProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;
  var nameController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var feedbackController = TextEditingController();
  List<CustomerReview> _customerReviewsList = [];
  late PostReviewResult _addReviewResult;
  late ResultState _addReviewState;
  String _addReviewMessage = '';

  CustomerReviewsProvider({required this.apiService, required this.id});

  List<CustomerReview> get customerReviewsList => _customerReviewsList;

  String get addReviewMessage => _addReviewMessage;

  PostReviewResult get addReviewResult => _addReviewResult;

  ResultState get addReviewState => _addReviewState;

  void setCustomerReviews(dynamic value) {
    _customerReviewsList = value;
    notifyListeners();
  }

  Future<dynamic> postReview() async {
    try {
      _addReviewState = ResultState.loading;
      notifyListeners();
      final data = await apiService.addReview(
          http.Client(), id, nameController.text, feedbackController.text);

      if (data.customerReviews.isEmpty) {
        _addReviewState = ResultState.noData;
        notifyListeners();
        return _addReviewMessage = 'Empty Data';
      } else {
        _addReviewState = ResultState.hasData;
        notifyListeners();
        return _addReviewResult = data;
      }
    } catch (e) {
      _addReviewState = ResultState.error;
      notifyListeners();
      if (e.toString() == "Failed host lookup: 'restaurant-api.dicoding.dev'") {
        return _addReviewMessage = "Check Your Internet Connection";
      }
      return _addReviewMessage = "Error-> $e";
    }
  }
}
