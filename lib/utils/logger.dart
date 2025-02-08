import 'package:flutter/foundation.dart';

class Logger {
  void log(String s){
    if(kDebugMode) {
      print(s);
    }
  }
}