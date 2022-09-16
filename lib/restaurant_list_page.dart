import 'package:flutter/material.dart';
import 'package:submission1_restaurant_app/restaurant.dart';
import 'package:submission1_restaurant_app/restaurant_detail_page.dart';
import 'package:submission1_restaurant_app/styles.dart';
import 'package:submission1_restaurant_app/widget/error_image_handler.dart';
import 'package:submission1_restaurant_app/widget/loading_builder.dart';
import 'package:submission1_restaurant_app/widget/rating_icon.dart';

class RestaurantsListPage extends StatefulWidget {
  static const routeName = '/article_list';

  const RestaurantsListPage({Key? key}) : super(key: key);

  @override
  State<RestaurantsListPage> createState() => _RestaurantsListPageState();
}

class _RestaurantsListPageState extends State<RestaurantsListPage> {
  late List<Restaurant> _restaurants;
  List<Restaurant> _filteredRestaurants = [];
  late final Set<String> _uniqueCity = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Restaurant App',
          style: Theme.of(context).textTheme.headline4,
        ),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/json/local_restaurant.json'),
        builder: (context, snapshot) {
          _restaurants = parseRestaurants(snapshot.data);
          _restaurants
              .where((element) => _uniqueCity.add(element.city))
              .toList();
          return Container(
            color: secondaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            'City :',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 10),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _uniqueCity.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return _buildCity(context, 'All');
                              } else {
                                return _buildCity(
                                    context, _uniqueCity.toList()[index - 1]);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: GridView.builder(
                    itemCount: _filteredRestaurants.isNotEmpty
                        ? _filteredRestaurants.length
                        : _restaurants.length,
                    itemBuilder: (context, index) {
                      return _buildRestaurants(
                          context,
                          _filteredRestaurants.isNotEmpty
                              ? _filteredRestaurants[index]
                              : _restaurants[index]);
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 15,
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCity(BuildContext context, String city) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () {
          setState(() {
            city != "All"
                ? _filteredRestaurants = _restaurants
                    .where((restaurant) => restaurant.city == city)
                    .toList()
                : _filteredRestaurants = _restaurants;
          });
          // print(filteredRestaurants.length);
        },
        child: Chip(
          backgroundColor: fourthColor,
          label: Text(city),
        ),
      ),
    );
  }

  Widget _buildRestaurants(BuildContext context, Restaurant restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RestaurantDetailPage.routeName,
            arguments: restaurant);
      },
      child: Card(
        color: thirdColor,
        elevation: 5,
        semanticContainer: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              child: Hero(
                tag: restaurant.id,
                child: Image.network(
                  restaurant.pictureId,
                  loadingBuilder: loadingBuilderImage,
                  errorBuilder: imageErrorHandler,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.width * 0.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.subtitle1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    restaurant.city,
                    style: Theme.of(context).textTheme.subtitle2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Rating(restaurant: restaurant),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
