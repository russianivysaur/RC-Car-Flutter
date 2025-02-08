import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rc_flutter/repository/bluetooth_repository.dart';
import 'package:rc_flutter/resources.dart';

import 'blocs/bluetooth/bluetooth_bloc.dart';
import 'blocs/bluetooth/bluetooth_bloc_events.dart';
import 'blocs/bluetooth/bluetooth_bloc_states.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: body(),
   );
  }

  Widget body() {
    return RepositoryProvider(create:(context) => BluetoothRepository(),
        child:BlocProvider(create:(context) => BluetoothBloc(BluetoothOffState(),
        RepositoryProvider.of<BluetoothRepository>(context)),
        child:Center(child:
        BlocBuilder<BluetoothBloc,BluetoothBlocState>(
            builder : (context,state) {
              if(state is BluetoothOnState){
                return scanButton(context);
              }else if (state is ScanCompletedState){
                return scannedDevices(context,state.scanResults);
              } else if(state is BluetoothOffState){
                return turnOnButton(context);
              }
              return Container();
            }
        ))));
  }

  Widget scanButton(BuildContext subContext) {
    BlocProvider.of<BluetoothBloc>(subContext).add(StartScanEvent());
    return Text("Scanning.....");
  }

  Widget turnOnButton(BuildContext subContext) {
    return Text("Turn on bluetooth");
  }

  Widget scannedDevices(BuildContext subContext,List<ScanResult> results) {
    Resources.toaster.toast(results.length.toString());
    return RefreshIndicator(onRefresh:() async {
      BlocProvider.of<BluetoothBloc>(subContext).add(StartScanEvent());
    },
      child: ListView.builder(
        itemCount:results.length,
        itemBuilder:(context,index) {
          return
            Text("${results[index].device.remoteId}: "
                "${results[index].advertisementData.advName} found");
        }
      ),
    );
  }
}