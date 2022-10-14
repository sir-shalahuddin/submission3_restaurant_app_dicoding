import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission3_restaurant_app/common/styles.dart';
import 'package:submission3_restaurant_app/data/api/api_service.dart';
import 'package:submission3_restaurant_app/data/model/customer_review.dart';
import 'package:submission3_restaurant_app/data/model/item.dart';
import 'package:submission3_restaurant_app/provider/customer_reviews.dart';
import 'package:submission3_restaurant_app/provider/favourite_restaurants.dart';
import 'package:submission3_restaurant_app/provider/restaurant_provider.dart';
import 'package:submission3_restaurant_app/provider/restaurants_provider.dart';
import 'package:submission3_restaurant_app/widgets/error_image_handler.dart';
import 'package:submission3_restaurant_app/widgets/loading_builder.dart';
import 'package:submission3_restaurant_app/widgets/rating_icon.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  RestaurantDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 1 / 3),
          child: AppBar(
            leading: Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(255, 255, 255, 0.85),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            actions: [
              Container(
                  margin: const EdgeInsets.only(right: 20, top: 10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(255, 255, 255, 0.85),
                  ),
                  child: ChangeNotifierProvider(
                    create: (_) => FavouriteProvider(),
                    builder: (ctx, child) {
                      return Consumer<RestaurantProvider>(
                          builder: (context2, state, _) {
                        return IconButton(
                          padding: const EdgeInsets.all(10),
                          onPressed: () {
                            state.isFavourite
                                ? {
                                    Provider.of<FavouriteProvider>(ctx,
                                            listen: false)
                                        .deleteRestaurant(state.restaurant.id!),
                                    state.setIsFavourite(false)
                                  }
                                : {
                                    Provider.of<FavouriteProvider>(ctx,
                                            listen: false)
                                        .addRestaurant(state.restaurant),
                                    state.setIsFavourite(true)
                                  };
                          },
                          icon: Icon(
                            state.isFavourite
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: primaryColor,
                          ),
                        );
                      });
                    },
                  ))
            ],
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              title: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(10),
                color: const Color.fromRGBO(255, 255, 255, 0.75),
                child: Text(
                  Provider.of<RestaurantProvider>(context, listen: false)
                      .restaurant
                      .name!,
                  style: Theme.of(context).textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              background: Hero(
                tag: Provider.of<RestaurantProvider>(context, listen: false)
                    .restaurant
                    .id!,
                child: Image.network(
                  "https://restaurant-api.dicoding.dev/images/medium/${Provider.of<RestaurantProvider>(context, listen: false).restaurant.pictureId}",
                  fit: BoxFit.cover,
                  loadingBuilder: loadingBuilderImage,
                  errorBuilder: imageErrorHandler,
                ),
              ),
            ),
          ),
        ),
        body: Consumer<RestaurantProvider>(builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.state == ResultState.hasData) {
            return Container(
              color: thirdColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 20),
                            Text(
                              state.result!.restaurant.city!,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                        Rating(restaurant: state.result!.restaurant,mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            state.result!.restaurant.description!,
                            textAlign: TextAlign.justify,
                            maxLines: state.isShow ? 100 : 2,
                            overflow: state.isShow == false
                                ? TextOverflow.ellipsis
                                : TextOverflow.visible,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          if (state.isShow)
                            const Divider(
                              height: 18,
                              thickness: 1,
                              indent: 5,
                              endIndent: 5,
                            ),
                          if (state.isShow)
                            Text(state.result!.restaurant.address!, textAlign: TextAlign.center,)
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          state.setIsShow(!state.isShow);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Text(
                                (state.isShow ? 'Read Less' : 'Read More'),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Icon(
                                state.isShow == true
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildMenu(context, 'Foods', 'assets/image/foods.png',
                        state.result!.restaurant.menus?.foods),
                    _buildMenu(context, 'Drinks', 'assets/image/drinks.png',
                        state.result!.restaurant.menus?.drinks),
                    ChangeNotifierProvider(
                      create: (context) => CustomerReviewsProvider(
                          apiService: ApiService(), id: state.restaurant.id!),
                      child: reviewSection(context, state),
                    )
                  ],
                ),
              ),
            );
          } else if (state.state == ResultState.noData) {
            return Center(
              child: Material(
                color: thirdColor,
                child: Text(state.message),
              ),
            );
          } else if (state.state == ResultState.error) {
            return Center(
              child: Material(
                color: thirdColor,
                child: Text(state.message),
              ),
            );
          } else {
            return const Center(
              child: Material(
                color: thirdColor,
                child: Text(''),
              ),
            );
          }
        }));
  }

  Column reviewSection(BuildContext context, RestaurantProvider state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Review",
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child:
              Consumer<CustomerReviewsProvider>(builder: (context, state2, _) {
            if (state2.customerReviewsList.isEmpty) {
              return buildListView(state2, state);
            } else {
              return buildListView(state2);
            }
          }),
        ),
      ],
    );
  }

  ListView buildListView(CustomerReviewsProvider reviewState,
      [RestaurantProvider? restaurantState]) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: restaurantState != null
            ? restaurantState.restaurant.customerReviews!.length + 1
            : reviewState.customerReviewsList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return buildAddReviewButton(context, reviewState);
          } else {
            return buildReviewTile(
                restaurantState?.restaurant.customerReviews ??
                    reviewState.customerReviewsList,
                index);
          }
        });
  }

  Card buildReviewTile(List<CustomerReview> state, int index) {
    return Card(
      color: fourthColor,
      child: ListTile(
        leading: const Icon(Icons.chat_outlined),
        title: Text(state[state.length - index].name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(state[state.length - index].review),
            Text(
              state[state.length - index].date,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Card buildAddReviewButton(
      BuildContext context, CustomerReviewsProvider state2) {
    return Card(
      color: secondaryColor,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              titlePadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              backgroundColor: thirdColor,
              title: const Text("How is it?"),
              content: SingleChildScrollView(
                child: Form(
                  key: state2.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: state2.nameController,
                        decoration: inputDecorationTemplate(
                            const EdgeInsets.symmetric(horizontal: 10),
                            "Enter your name"),
                        validator: (value) =>
                            validatorInput(value, "Please enter your name first"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: state2.feedbackController,
                        decoration: inputDecorationTemplate(
                            const EdgeInsets.symmetric(horizontal: 10),
                            "Enter your Feedback"),
                        validator: (value) => validatorInput(
                            value, "Please enter your feedback first"),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (state2.formKey.currentState!.validate()) {
                      Provider.of<CustomerReviewsProvider>(context,
                              listen: false)
                          .postReview()
                          .then((value) => {
                                if (value.runtimeType != String)
                                  state2
                                      .setCustomerReviews(value.customerReviews)
                                else
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar)
                              });
                      state2.nameController.clear();
                      state2.feedbackController.clear();
                      Navigator.of(ctx).pop();
                      if (Provider.of<CustomerReviewsProvider>(context,
                                  listen: false)
                              .addReviewState ==
                          ResultState.error) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  child: const Text('Submit'),
                )
              ],
            ),
          );
        },
        child: const ListTile(
          title: Text(
            "Add review",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  String? validatorInput(value, warningText) {
    if (value == null || value.isEmpty) {
      return warningText;
    }
    return null;
  }

  InputDecoration inputDecorationTemplate(
      EdgeInsetsGeometry padding, String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: fourthColor,
      contentPadding: padding,
      border: const OutlineInputBorder(),
      hintText: hintText,
    );
  }

  Column _buildMenu(
      BuildContext context, String title, String image, List<Item>? item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        SizedBox(
          height: 180,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: item?.length,
            itemBuilder: (context, index) {
              return _buildItem(context, image, item![index]);
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 1,
              childAspectRatio: 1 / 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, String image, Item item) {
    return Card(
      color: fourthColor,
      elevation: 5,
      semanticContainer: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image(
              image: AssetImage(image),
              fit: BoxFit.contain,
              height: 100,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final snackBar = SnackBar(
    content: const Text('Check Your Internet Connection'),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: () {},
    ),
  );
}
