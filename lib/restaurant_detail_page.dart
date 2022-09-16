import 'package:flutter/material.dart';
import 'package:submission1_restaurant_app/restaurant.dart';
import 'package:submission1_restaurant_app/styles.dart';
import 'package:submission1_restaurant_app/widget/error_image_handler.dart';
import 'package:submission1_restaurant_app/widget/loading_builder.dart';
import 'package:submission1_restaurant_app/widget/rating_icon.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/article_detail';

  final Restaurant restaurant;

  const RestaurantDetailPage({Key? key, required this.restaurant})
      : super(key: key);

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  bool _isShow = false;

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
      body: SingleChildScrollView(
        child: Container(
          color: thirdColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: widget.restaurant.id,
                createRectTween: (Rect? begin, Rect? end) {
                  return MaterialRectCenterArcTween(begin: begin, end: end);
                },
                child: Image.network(
                  widget.restaurant.pictureId,
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
                              widget.restaurant.name,
                              style: Theme.of(context).textTheme.headline5,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Rating(restaurant: widget.restaurant)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 20),
                        Text(
                          widget.restaurant.city,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget.restaurant.description,
                        textAlign: TextAlign.justify,
                        maxLines: _isShow ? 100 : 2,
                        overflow: _isShow == false
                            ? TextOverflow.ellipsis
                            : TextOverflow.visible,
                        style: Theme.of(context).textTheme.bodyText2,
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
                          setState(() {
                            _isShow = !_isShow;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Text(
                                (_isShow ? 'Read Less' : 'Read More'),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Icon(
                                _isShow == true
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
                        widget.restaurant.menus.foods),
                    _buildMenu('Drinks', 'assets/image/drinks.png',
                        widget.restaurant.menus.drinks)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildMenu(String title, String image, List<Item> item) {
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
            itemCount: item.length,
            itemBuilder: (context, index) {
              return _buildItem(context, image, item[index]);
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
}
