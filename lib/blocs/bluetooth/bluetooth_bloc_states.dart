import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothBlocState {}


class BluetoothOffState extends BluetoothBlocState{}

class BluetoothOnState extends BluetoothBlocState{}

class ScanResultsState extends BluetoothBlocState{
  List<ScanResult> scanResults;
  ScanResultsState(this.scanResults);
}

class ScanCompletedState extends BluetoothBlocState{

}

class ConnectedState extends BluetoothBlocState{
  BluetoothCharacteristic characteristic;
  ConnectedState(this.characteristic);
}