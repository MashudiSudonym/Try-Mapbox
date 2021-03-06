import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:meta/meta.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  MapsCubit() : super(MapsInitial());

  MapboxMapController _mapController;
  GeolocatorPlatform _geoLocatorPlatform = GeolocatorPlatform.instance;
  Position _currentPosition;
  Logger _logger;

  void initMapController(MapboxMapController mapController) {
    this._mapController = mapController;

    // detect location permission, and get gps location to setup camera position before set maps controller
    getCurrentLocation();

    emit(MapsInit(_mapController));
  }

  Future<void> getCurrentLocation() async {
    _checkLocationPermissionStatus();

    await _geoLocatorPlatform
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((Position position) {
      _currentPosition = position;
    }).catchError((e) {
      _logger.e(e);
    });

    _addExampleMarker();
    _myPosition();
  }

  Future<void> _checkLocationPermissionStatus() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(
        LocationPermissionStatus('Location services are disabled.'),
      );
    } else {
      emit(
        LocationPermissionStatus('Location services are enable.'),
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      emit(
        LocationPermissionStatus(
            'Location permissions are permantly denied, we cannot request permissions.'),
      );
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        emit(
          LocationPermissionStatus(
              'Location permissions are denied (actual value: $permission).'),
        );
      }
    }
  }

  Future<void> _myPosition() async {
    await _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 17,
          target: (_currentPosition != null)
              ? LatLng(
                  _currentPosition.latitude,
                  _currentPosition.longitude,
                )
              : LatLng(
                  -6.634757521999479,
                  110.71668007267021,
                ),
        ),
      ),
    );
  }

  Future<void> _addExampleMarker() async {
    await _mapController.addSymbol(
      SymbolOptions(
        geometry: LatLng(
          -6.591500981979604,
          110.66710503884575,
        ),
        iconImage: 'assets/custom-icon.png',
        iconSize: 2,
      ),
    );
  }
}
