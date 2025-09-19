import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial()) {
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // الخدمة مقفولة – بلّغ المستخدم وافتح إعدادات الموقع
      await Geolocator.openLocationSettings();
    }

    emit(LocationLoading());

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationError("خدمة الموقع غير مفعلة"));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationError("تم رفض صلاحية الموقع"));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(LocationError("تم رفض صلاحية الموقع دائمًا"));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      String address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      emit(LocationLoaded(address));
    } catch (e) {
      emit(LocationError("فشل في جلب الموقع"));
    }
  }
}

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final String address;

  LocationLoaded(this.address);
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
