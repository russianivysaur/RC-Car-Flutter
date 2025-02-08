import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../resources.dart';



class BluetoothRepository {
  Future<void> startBluetooth() async {
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: false);
    FlutterBluePlus.logs.listen(Resources.logger.log);
  }
}