import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:try_mapbox/constants.dart';
import 'package:try_mapbox/cubit/maps_cubit.dart';
import 'package:try_mapbox/simple_bloc_observer.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MapBox Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (_) => MapsCubit(),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  void onStyleLoadedCallback() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<MapsCubit, MapsState>(
        builder: (context, state) {
          return MapboxMap(
            accessToken: ACCESS_TOKEN,
            initialCameraPosition: const CameraPosition(
              zoom: 14.0,
              target: LatLng(
                -6.591500981979604,
                110.66710503884575,
              ),
            ),
            onMapCreated: (controller) {
              context.read<MapsCubit>().initMapController(controller);
            },
            styleString: MapboxStyles.SATELLITE_STREETS,
            onStyleLoadedCallback: onStyleLoadedCallback,
          );
        },
      ),
    );
  }
}
