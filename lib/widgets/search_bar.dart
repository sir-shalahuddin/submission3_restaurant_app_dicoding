import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission3_restaurant_app/common/styles.dart';
import 'package:submission3_restaurant_app/provider/restaurants_provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        onSubmitted: (value) {
          Provider.of<RestaurantsProvider>(context, listen: false)
              .searchRestaurant(value.trim().isEmpty ? " " : value.trim());
        },
        decoration: const InputDecoration(
          filled: true,
          fillColor: fourthColor,
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(),
          hintText: "Search",
        ),
      ),
    );
  }
}
