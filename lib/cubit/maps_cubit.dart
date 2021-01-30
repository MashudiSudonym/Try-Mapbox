import 'package:bloc/bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:meta/meta.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  MapsCubit() : super(MapsInitial());

  MapboxMapController mapController;
  CameraPosition cameraPosition;

  void initMapController(MapboxMapController mapController) {
    this.mapController = mapController;

    emit(MapsLoad(mapController));
  }
}
