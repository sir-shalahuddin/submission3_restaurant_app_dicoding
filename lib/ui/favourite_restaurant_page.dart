import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission3_restaurant_app/common/styles.dart';
import 'package:submission3_restaurant_app/provider/favourite_restaurants.dart';
import 'package:submission3_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:submission3_restaurant_app/widgets/rating_icon.dart';

class FavouriteRestaurantPage extends StatelessWidget {
  static const routeName = '/favourite_restaurant';

  const FavouriteRestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: AppBar(
          backgroundColor: thirdColor,
          title: const Text(
            'Favourite Restaurant',
          ),
        ),
        body: Consumer<FavouriteProvider>(builder: (context, state, _) {
          return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                    color: Colors.black,
                  ),
              itemCount: state.restaurant.length,
              padding: const EdgeInsets.all(5),
              itemBuilder: (ctx, index) {
                return Dismissible(
                  key: Key(state.restaurant[index].id!),
                  onDismissed: (direction) {
                    state.deleteRestaurant(state.restaurant[index].id!);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        content:
                            Text('${state.restaurant[index].name} dismissed'),
                      ),
                    );
                  },
                  background: Container(color: primaryColor),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RestaurantDetailPage.routeName,
                          arguments: state.restaurant[index]).then((value) =>
                      {state.getAllRestaurants()});
                    },
                    leading: Image.network(
                      "https://restaurant-api.dicoding.dev/images/small/${state.restaurant[index].pictureId}",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(ctx).size.width * 0.25,
                    ),
                    title: Text(
                      "${state.restaurant[index].name!}\n${state.restaurant[index].address!}",
                    ),
                    subtitle: Rating(
                      restaurant: state.restaurant[index],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                    trailing: Container(width: 24.0),
                  ),
                );
              });
        }));
  }
}
