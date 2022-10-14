import 'package:flutter/material.dart';
import 'package:submission3_restaurant_app/data/model/restaurant.dart';

class Rating extends StatelessWidget {
  final Restaurant restaurant;
  final MainAxisAlignment mainAxisAlignment;
  const Rating({Key? key, required this.restaurant, required this.mainAxisAlignment }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Row(
          children: List.generate(
            5,
            (index) {
              if (restaurant.rating! - index >= 1) {
                return const Icon(
                  Icons.star,
                  size: 16,
                );
              } else if (restaurant.rating! - index > 0) {
                return const Icon(
                  Icons.star_half,
                  size: 16,
                );
              } else {
                return const Icon(
                  Icons.star_outline,
                  size: 16,
                );
              }
            },
          ),
        ),
        Text(
          restaurant.rating.toString(),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
