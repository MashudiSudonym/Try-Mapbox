part of 'maps_cubit.dart';

@immutable
abstract class MapsState {}

class MapsInitial extends MapsState {}

class MapsInit extends MapsState {
  final MapboxMapController mapController;

  MapsInit(this.mapController);
}

class LocationPermissionStatus extends MapsState {
  final String message;

  LocationPermissionStatus(this.message);
}
