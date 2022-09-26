import 'package:flutter/material.dart';
import 'package:submission2_restaurant_app/data/model/restaurant.dart';

class Rating extends StatelessWidget {
  final Restaurant restaurant;

  const Rating({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: List.generate(
                5,
                (index) {
                  if (restaurant.rating - index >= 1) {
                    return const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.star,
                        size: 16,
                      ),
                    );
                  } else if (restaurant.rating - index > 0) {
                    return const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.star_half,
                        size: 16,
                      ),
                    );
                  } else {
                    return const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.star_outline,
                        size: 16,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              restaurant.rating.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
