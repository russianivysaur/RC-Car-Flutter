import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BluetoothBlocEvent {}


class StartBluetoothEvent extends BluetoothBlocEvent{}

class ChangeBluetoothStateEvent extends BluetoothBlocEvent{
  BluetoothAdapterState state;
  ChangeBluetoothStateEvent(this.state);
}

class StartScanEvent extends BluetoothBlocEvent{}


class ConnectToDeviceEvent extends BluetoothBlocEvent{
  BluetoothDevice device;
  ConnectToDeviceEvent(this.device);
}
