package com.bkonyi.garagedooropener;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.geofencing.GeofencingService;
import io.flutter.embedding.engine.FlutterEngine;

public class Application extends FlutterApplication implements PluginRegistrantCallback {
  @Override
  public void onCreate() {
    super.onCreate();
    GeofencingService.setPluginRegistrant(this);
  }

  @Override
  public void registerWith(PluginRegistry registry) {
//    GeneratedPluginRegistrant.registerWith(registry);
    GeneratedPluginRegistrant.registerWith((FlutterEngine) registry);
  }
}