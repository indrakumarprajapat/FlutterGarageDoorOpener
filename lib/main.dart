import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geofencing/geofencing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/common.dart';
import 'src/geofence_trigger.dart';

void main() => runApp(new GarageDoorOpener());

String localFile(path) => Platform.script.resolve(path).toFilePath();

class GarageDoorOpener extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Garage Door Opener',
      theme: ThemeData.light(),
      home: new GarageDoorRemotePage(title: 'Garage Door Remote'),
    );
  }
}

class GarageDoorRemotePage extends StatefulWidget {
  GarageDoorRemotePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GarageDoorRemoteState createState() => new _GarageDoorRemoteState();
}

class _GarageDoorRemoteState extends State<GarageDoorRemotePage> {
  static const kProximityToggleKey = 'proximity_toggle_state';
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _proximityTriggerEnabled =
          sharedPreferences.getBool(kProximityToggleKey) ?? false;
    });
  }

  static const double _outerButtonWidth = 425.0;
  static const double _innerButtonWidth = _outerButtonWidth * (5.0 / 6.0);

  final _doorToggleButton = Stack(
    alignment: Alignment(0.0, 0.0),
    children: <Widget>[
      Container(
        width: _outerButtonWidth,
        height: _outerButtonWidth,
        color: Colors.black87,
      ),
      Material(
          type: MaterialType.card,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.grey[400],
          child: InkWell(
            // onTap: GarageDoorRemote.triggerDoor,
            child: Container(
              width: _innerButtonWidth,
              height: _innerButtonWidth,
              padding: const EdgeInsets.all(20.0),
            ),
          )),
      const Text(
        'TOGGLE',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 64.0),
      )
    ],
  );

  bool _proximityTriggerEnabled = false;
  Widget _proximityTriggerToggle() => Container(
      padding: const EdgeInsets.fromLTRB(26.0, 2.5, 26.0, 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text('Proximity Trigger',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
          Switch(
            value: _proximityTriggerEnabled,
            onChanged: (bool state) async {
              setState(() {
                _proximityTriggerEnabled = state;
                sharedPreferences.setBool(
                    kProximityToggleKey, _proximityTriggerEnabled);
              });
              if (state) {
                await GeofencingManager.registerGeofence(
                    GeofenceTrigger.homeRegion,
                    GeofenceTrigger.homeGeofenceCallback);
              } else {
                await GeofencingManager.removeGeofence(
                    GeofenceTrigger.homeRegion);
              }
            },
          ),
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        children: [
          _doorToggleButton,
          Divider(
            color: Colors.black,
            height: 5.0,
          ),
          // _buildButton('Close in 30 seconds', _timedClose),
          // _buildButton('Open for 60 seconds', _timedOpenThenClose),
          Divider(
            color: Colors.black,
            height: 5.0,
          ),
          _proximityTriggerToggle(),
          Divider(
            color: Colors.black,
            height: 5.0,
          )
        ],
      ),
    );
  }
}
