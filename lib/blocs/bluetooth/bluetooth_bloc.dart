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
    on<ConnectToDeviceEvent>(connectToDevice);
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
      emit(ScanResultsState(results));
    });
    FlutterBluePlus.cancelWhenScanComplete(sub);
    await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;
    await FlutterBluePlus.startScan(
        timeout: Duration(seconds:20));

    await FlutterBluePlus.isScanning.where((val) => val == false).first;
    Resources.logger.log("end of scan");
    emit(ScanCompletedState());
  }



  void connectToDevice(ConnectToDeviceEvent event,emit) async{
    await event.device.connect();
    List<BluetoothService> services = await event.device.discoverServices();
    for(BluetoothService service in services) {
      if(service.uuid.toString() == "12345678-1234-5678-1234-56789abcdef0"){
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        for(BluetoothCharacteristic characteristic in characteristics) {
          if(characteristic.uuid.toString() == "12345678-1234-5678-1234-56789abcdef1"){
            emit(ConnectedState(characteristic));
          }
        }
      }
    }
  }

}