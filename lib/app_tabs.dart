import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lingon/map.dart';

class AppTabs extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<AppTabs> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription<IosNotificationSettings> iosSubscription;

  Future<void> _saveDeviceToken(String userId) async {
    // Get the token for this device
    final String fcmToken = await _fcm.getToken();
    print('fcmtoken $fcmToken');
    // Save it to Firestore
    if (fcmToken != null) {
      final DocumentReference tokens = _db
          .collection('users')
          .document(userId)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData(<String, dynamic>{
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      MapPage(),
      const Text(
        'Index 1: Chat',
        style: optionStyle,
      ),
      const Text(
        'Index 2: settings',
        style: optionStyle,
      ),
    ];
    /*
    if (Platform.isIOS) {
      iosSubscription =
          _fcm.onIosSettingsRegistered.listen((IosNotificationSettings data) {
        _saveDeviceToken(userData.userData.id);
      });

      _fcm.requestNotificationPermissions(const IosNotificationSettings());
    } else {
      _saveDeviceToken(userData.userData.id);
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
     */
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            title: Text('Chat'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    iosSubscription?.cancel();
    super.dispose();
  }
}
