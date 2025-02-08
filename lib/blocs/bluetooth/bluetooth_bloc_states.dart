import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothBlocState {}


class BluetoothOffState extends BluetoothBlocState{}

class BluetoothOnState extends BluetoothBlocState{}

class ScanCompletedState extends BluetoothBlocState{
  List<ScanResult> scanResults;
  ScanCompletedState(this.scanResults);
}