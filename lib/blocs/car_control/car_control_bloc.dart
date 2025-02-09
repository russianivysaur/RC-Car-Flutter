
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class CarControlCubit extends Cubit {
  BluetoothCharacteristic characteristic;
  CarControlCubit(super.initialState,this.characteristic);

  void input(Direction direction) async {
    await characteristic.write(direction.name.codeUnits);
  }
}


enum Direction {
  up,right,down,left,none
}