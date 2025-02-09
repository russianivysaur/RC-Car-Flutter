import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rc_flutter/repository/bluetooth_repository.dart';
import 'package:rc_flutter/resources.dart';

import 'blocs/bluetooth/bluetooth_bloc.dart';
import 'blocs/bluetooth/bluetooth_bloc_events.dart';
import 'blocs/bluetooth/bluetooth_bloc_states.dart';
import 'blocs/car_control/car_control_bloc.dart';

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
        BlocConsumer<BluetoothBloc,BluetoothBlocState>(
            listener:(context,state){
              if(state is BluetoothOnState){
                scan(context);
              }else if (state is ScanCompletedState){
                Navigator.pop(context);
              }
            },
            builder : (context,state) {
              if (state is ScanResultsState){
                return scannedDevices(context,state.scanResults);
              } else if(state is BluetoothOffState){
                return turnOnText();
              }else if (state is ConnectedState){
                return controls(state.characteristic);
              }
              return Container();
            },buildWhen:(prev,curr) => curr is! ScanCompletedState
        ))));
  }


  Widget turnOnText() {
    return Text("Turn on bluetooth");
  }

  Widget scannedDevices(BuildContext subContext,List<ScanResult> results) {
    Resources.toaster.toast(results.length.toString());
    return RefreshIndicator(onRefresh:() async {
      scan(subContext);
    },
      child: ListView.builder(
        itemCount:results.length,
        itemBuilder:(con,index) {
          return ListTile(title:Text("${results[index].device.remoteId}: "
              "${results[index].advertisementData.advName} found"),onTap: () async {
            BlocProvider.of<BluetoothBloc>(subContext).add(ConnectToDeviceEvent(results[index].device));
          },);
        }
      ),
    );
  }


  Widget controls(BluetoothCharacteristic characteristic) {
    CarControlCubit carControlCubit = CarControlCubit(Direction.none,characteristic);
    return SizedBox(height:200,
      child: Column(children:[
        Row(mainAxisAlignment:MainAxisAlignment.center,children:[
          IconButton(onPressed:(){
            carControlCubit.input(Direction.up);
          },
          icon:Icon(Icons.arrow_circle_up))
        ]),
        SizedBox(height:10),
        Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children:[
          IconButton(onPressed:(){
            carControlCubit.input(Direction.left);
          },
              icon:Icon(Icons.arrow_circle_left)),
          IconButton(onPressed:(){
            carControlCubit.input(Direction.right);
          },
              icon:Icon(Icons.arrow_circle_right))
        ]),
        SizedBox(height:10),
        Row(mainAxisAlignment:MainAxisAlignment.center,children:[
          IconButton(onPressed:(){
            carControlCubit.input(Direction.down);
          },
              icon:Icon(Icons.arrow_circle_down))
        ])
      ]),
    );
  }


  void scan(BuildContext subContext) {
    BlocProvider.of<BluetoothBloc>(subContext).add(StartScanEvent());
    showDialog(context: context,builder: (context){
      return Container(child:Text("Scanning....."));
    },barrierDismissible: false);
  }
}