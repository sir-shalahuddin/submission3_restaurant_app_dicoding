import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission3_restaurant_app/provider/setting.dart';
import 'package:submission3_restaurant_app/widgets/custom_dialog.dart';

class SettingPage extends StatelessWidget {
  static const routeName = '/setting';

  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            ListTile(
              title: const Text('Notification'),
              trailing: Consumer<SettingProvider>(
                builder: (context, scheduled, _) {
                  return Switch.adaptive(
                    value: scheduled.isReminderOn,
                    onChanged: (value) {
                      if (Platform.isIOS) {
                        customDialog(context);
                      } else {
                        scheduled.scheduledNotification(value);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );

  }
}
