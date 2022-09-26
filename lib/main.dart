import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission2_restaurant_app/common/styles.dart';
import 'package:submission2_restaurant_app/data/api/api_service.dart';
import 'package:submission2_restaurant_app/provider/restaurant_provider.dart';
import 'package:submission2_restaurant_app/provider/restaurants_provider.dart';
import 'package:submission2_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:submission2_restaurant_app/ui/restaurant_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              onPrimary: Colors.black,
              secondary: secondaryColor,
            ),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: myTextTheme,
        appBarTheme: const AppBarTheme(elevation: 0),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: secondaryColor,
            textStyle: const TextStyle(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
            ),
          ),
        ),
      ),
      initialRoute: RestaurantsListPage.routeName,
      routes: {
        RestaurantsListPage.routeName: (context) => ChangeNotifierProvider(
              create: (_) => RestaurantsProvider(
                apiService: ApiService(),
              ),
              child: const RestaurantsListPage(),
            ),
        RestaurantDetailPage.routeName: (context) => ChangeNotifierProvider(
              create: (_) => RestaurantProvider(
                  apiService: ApiService(),
                  id: ModalRoute.of(context)?.settings.arguments as String),
              child: const RestaurantDetailPage(),
            ),
      },
    );
  }
}
