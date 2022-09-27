import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission2_restaurant_app/common/styles.dart';
import 'package:submission2_restaurant_app/data/model/restaurant.dart';
import 'package:submission2_restaurant_app/provider/restaurants_provider.dart';
import 'package:submission2_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:submission2_restaurant_app/widgets/error_image_handler.dart';
import 'package:submission2_restaurant_app/widgets/loading_builder.dart';
import 'package:submission2_restaurant_app/widgets/rating_icon.dart';
import 'package:submission2_restaurant_app/widgets/search_bar.dart';

class RestaurantsListPage extends StatelessWidget {
  static const routeName = '/article_list';

  const RestaurantsListPage({Key? key}) : super(key: key);

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
      body: Container(
        color: secondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SearchBar(),
            Expanded(
              flex: 30,
              child: Consumer<RestaurantsProvider>(
                builder: (context, state, _) {
                  if (state.state == ResultState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.state == ResultState.hasData) {
                    return GridView.builder(
                      itemCount: state.restaurantList.length,
                      itemBuilder: (context, index) {
                        return _buildRestaurants(
                            context, state.restaurantList[index]);
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 15,
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 4,
                      ),
                    );
                  } else if (state.state == ResultState.noData) {
                    return Center(
                      child: Material(
                        color: secondaryColor,
                        child: Text(state.message),
                      ),
                    );
                  } else if (state.state == ResultState.error) {
                    return Center(
                      child: Material(
                        color: secondaryColor,
                        child: Text(state.message),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Material(
                        child: Text(''),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurants(BuildContext context, Restaurant restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RestaurantDetailPage.routeName,
            arguments: restaurant.id);
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
                bottomLeft: Radius.circular(20),
              ),
              child: Hero(
                tag: restaurant.id,
                child: Image.network(
                  "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
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
