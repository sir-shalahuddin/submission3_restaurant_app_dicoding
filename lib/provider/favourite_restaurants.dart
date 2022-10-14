import 'dart:async';

import 'package:flutter/material.dart';
import 'package:submission3_restaurant_app/data/local_db/db_helper.dart';
import 'package:submission3_restaurant_app/data/model/restaurant.dart';

class FavouriteProvider extends ChangeNotifier {
 List<Restaurant> _restaurants = [];
 late DatabaseHelper _dbHelper;

 List<Restaurant> get restaurant => _restaurants;

 FavouriteProvider(){
   _dbHelper = DatabaseHelper();
   _getAllRestaurants().then((value) => setRestaurant(value));
 }

 Future<void> addRestaurant(Restaurant restaurant) async {
   await _dbHelper.insertRestaurant(restaurant);
   _getAllRestaurants();
 }

 Future<dynamic> _getAllRestaurants() async {
   _restaurants = await _dbHelper.getRestaurants();
   notifyListeners();
   return _restaurants;
 }

 void deleteRestaurant(String id) async {
   await _dbHelper.deleteRestaurant(id);
   _getAllRestaurants();
 }

 void setRestaurant(List<Restaurant> value) {
   _restaurants = value;
   notifyListeners();
 }


}
