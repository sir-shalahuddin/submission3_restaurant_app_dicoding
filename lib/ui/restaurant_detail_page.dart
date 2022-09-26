import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission2_restaurant_app/common/styles.dart';
import 'package:submission2_restaurant_app/data/api/api_service.dart';
import 'package:submission2_restaurant_app/data/model/item.dart';
import 'package:submission2_restaurant_app/provider/customer_reviews.dart';
import 'package:submission2_restaurant_app/provider/restaurant_provider.dart';
import 'package:submission2_restaurant_app/provider/restaurants_provider.dart';
import 'package:submission2_restaurant_app/widgets/error_image_handler.dart';
import 'package:submission2_restaurant_app/widgets/loading_builder.dart';
import 'package:submission2_restaurant_app/widgets/rating_icon.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  const RestaurantDetailPage({Key? key}) : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(255, 255, 255, 0.85),
          ),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
      ),
      body: Container(
        color: secondaryColor,
        child: Consumer<RestaurantProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              return SingleChildScrollView(
                child: Container(
                  color: thirdColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: state.result!.restaurant.id,
                        createRectTween: (Rect? begin, Rect? end) {
                          return MaterialRectCenterArcTween(
                              begin: begin, end: end);
                        },
                        child: Image.network(
                          "https://restaurant-api.dicoding.dev/images/medium/${state.result!.restaurant.pictureId}",
                          loadingBuilder: loadingBuilderImage,
                          errorBuilder: imageErrorHandler,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  flex: 4,
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: Text(
                                      state.result!.restaurant.name,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Rating(
                                          restaurant:
                                              state.result!.restaurant)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 20),
                                Text(
                                  state.result!.restaurant.city,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.result!.restaurant.description,
                                    textAlign: TextAlign.justify,
                                    maxLines: state.isShow ? 100 : 2,
                                    overflow: state.isShow == false
                                        ? TextOverflow.ellipsis
                                        : TextOverflow.visible,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  if (state.isShow)
                                    const Divider(
                                      height: 18,
                                      thickness: 1,
                                      indent: 5,
                                      endIndent: 5,
                                    ),
                                  if (state.isShow)
                                    Text(state.result!.restaurant.address!)
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
                                        (state.isShow
                                            ? 'Read Less'
                                            : 'Read More'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
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
                            _buildMenu('Foods', 'assets/image/foods.png',
                                state.result!.restaurant.menus?.foods),
                            _buildMenu('Drinks', 'assets/image/drinks.png',
                                state.result!.restaurant.menus?.drinks),
                            ChangeNotifierProvider(
                              create: (context) => CustomerReviewsProvider(
                                  apiService: ApiService(), id: state.id),
                              child: reviewSection(context, state),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
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
                  color: secondaryColor,
                  child: Text(''),
                ),
              );
            }
          },
        ),
      ),
    );
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
            ? restaurantState.customerReviewsList.length + 1
            : reviewState.customerReviewsList.length + 1,
        itemBuilder: (context, index) {
          if (index <=
              (restaurantState != null
                  ? restaurantState.customerReviewsList.length - 1
                  : reviewState.customerReviewsList.length - 1)) {
            return buildReviewTile(restaurantState ?? reviewState, index);
          } else {
            return buildAddReviewButton(context, reviewState);
          }
        });
  }

  Card buildReviewTile(dynamic state, int index) {
    return Card(
      color: fourthColor,
      child: ListTile(
        leading: const Icon(Icons.chat_outlined),
        title: Text(state.customerReviewsList[index].name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(state.customerReviewsList[index].review),
            Text(
              state.customerReviewsList[index].date,
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
                contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                actionsPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                backgroundColor: thirdColor,
                title: const Text("How is it?"),
                content: Form(
                  key: state2.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: state2.nameController,
                        decoration: inputDecorationTemplate(
                            const EdgeInsets.symmetric(horizontal: 20),
                            "Enter your name"),
                        validator: (value) => validatorInput(
                            value, "Please enter your name first"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: state2.feedbackController,
                        decoration: inputDecorationTemplate(
                            const EdgeInsets.fromLTRB(20, 50, 20, 50),
                            "Enter your Feedback"),
                        validator: (value) => validatorInput(
                            value, "Please enter your feedback first"),
                      ),
                    ],
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
                                    state2.setCustomerReviews(
                                        value.customerReviews)
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
        ));
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

  Column _buildMenu(String title, String image, List<Item>? item) {
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
