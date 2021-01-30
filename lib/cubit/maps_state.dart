part of 'maps_cubit.dart';

@immutable
abstract class MapsState {}

class MapsInitial extends MapsState {}

class MapsLoad extends MapsState {
  final MapboxMapController mapController;

  MapsLoad(this.mapController);
}
