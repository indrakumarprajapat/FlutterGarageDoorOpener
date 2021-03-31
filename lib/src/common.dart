import 'dart:async';

import 'package:geofencing/geofencing.dart';

Future<void> initialize() async {
  print('initializing');
  await GeofencingManager.initialize();
}
