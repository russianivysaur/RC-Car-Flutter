import 'package:fluttertoast/fluttertoast.dart';

class Toaster{
  void toast(String s) {
    Fluttertoast.showToast(msg: s);
  }
}