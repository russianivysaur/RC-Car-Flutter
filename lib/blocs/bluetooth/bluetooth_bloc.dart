import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../repository/bluetooth_repository.dart';
import '../../resources.dart';
import 'bluetooth_bloc_events.dart';
import 'bluetooth_bloc_states.dart';

class BluetoothBloc extends Bloc<BluetoothBlocEvent,BluetoothBlocState> {
  BluetoothRepository repo;
  BluetoothBloc(super.initialState,this.repo){
    on<ChangeBluetoothStateEvent>(changeBluetoothState);
    on<StartScanEvent>(scan);
    on<ScanCompletedEvent>(scanCompleted);
    startBluetooth();
  }

  void startBluetooth() async {
    await repo.startBluetooth();
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state){
      add(ChangeBluetoothStateEvent(state));
    });
  }

  void changeBluetoothState(ChangeBluetoothStateEvent event,emit) {
    if(event.state==BluetoothAdapterState.on){
      emit(BluetoothOnState());
    }else{
      emit(BluetoothOffState());
    }
  }


  void scan(event,emit) async {
    var sub = FlutterBluePlus.onScanResults.listen((results){
      Resources.logger.log(results.toString());
      add(ScanCompletedEvent(results));
    });
    FlutterBluePlus.cancelWhenScanComplete(sub);
    await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;
    await FlutterBluePlus.startScan(
        timeout: Duration(seconds:20));

    await FlutterBluePlus.isScanning.where((val) => val == false).first;
    Resources.logger.log("end of scan");
  }

  void scanCompleted(ScanCompletedEvent event,emit) {
    emit(ScanCompletedState(event.scanResults));
  }
}