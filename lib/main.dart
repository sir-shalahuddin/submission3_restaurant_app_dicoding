import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:submission3_restaurant_app/common/styles.dart';
import 'package:submission3_restaurant_app/data/api/api_service.dart';
import 'package:submission3_restaurant_app/data/model/restaurant.dart';
import 'package:submission3_restaurant_app/provider/favourite_restaurants.dart';
import 'package:submission3_restaurant_app/provider/restaurant_provider.dart';
import 'package:submission3_restaurant_app/provider/restaurants_provider.dart';
import 'package:submission3_restaurant_app/provider/setting.dart';
import 'package:submission3_restaurant_app/ui/favourite_restaurant_page.dart';
import 'package:submission3_restaurant_app/ui/restaurant_detail_page.dart';
import 'package:submission3_restaurant_app/ui/restaurant_list_page.dart';
import 'package:submission3_restaurant_app/ui/setting_page.dart';
import 'package:submission3_restaurant_app/utils/background_service.dart';
import 'package:submission3_restaurant_app/utils/notification_helper.dart';

import 'common/navigation.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
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
          scaffoldBackgroundColor: secondaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: myTextTheme,
          appBarTheme: const AppBarTheme(color: thirdColor, elevation: 0),
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
                    restaurant: ModalRoute.of(context)?.settings.arguments
                        as Restaurant),
                child: RestaurantDetailPage(),
              ),
          FavouriteRestaurantPage.routeName: (context) =>
              ChangeNotifierProvider(
                create: (_) => FavouriteProvider(),
                child: const FavouriteRestaurantPage(),
              ),
          SettingPage.routeName: (context) => ChangeNotifierProvider(
                create: (_) => SettingProvider(),
                child: const SettingPage(),
              )
        },
        navigatorKey: navigatorKey);
  }
}
