import 'dart:async';

import 'package:assassin_client/colors.dart';
import 'package:assassin_client/widgets/template_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationTestingPage extends StatelessWidget {
  const NotificationTestingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: 'NOTIFICATIONS',
      child: NotificationList(),
    );
  }
}

class NotificationList extends StatefulWidget {
  const NotificationList({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  late final FirebaseMessaging _messaging;
  late final StreamSubscription _subscription;

  List<Widget> notifications = [];

  void registerNotification() async {
    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    setState(() {
      notifications.add(
        ElevatedButton(
          onPressed: () async => Clipboard.setData(
              ClipboardData(text: await _messaging.getToken())),
          child: Text('Copy Token'),
        ),
      );
    });

    print(await _messaging.getToken());

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // For handling the received notifications
      _subscription =
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        final notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          notifications.add(notification);
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    super.initState();

    registerNotification();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: notifications,
      ),
    );
  }
}

class PushNotification extends StatelessWidget {
  const PushNotification({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  final String? title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final style1 = Theme.of(context)
        .textTheme
        .headline5!
        .copyWith(color: assassinDarkBlue);

    final style2 = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: assassinDarkBlue);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: assassinBlue,
        ),
        child: Column(
          children: [
            Text(title ?? 'No title', style: style1),
            Text(body ?? 'No body', style: style2),
          ],
        ),
      ),
    );
  }
}
