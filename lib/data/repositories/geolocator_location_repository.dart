import 'package:gallaemalae/domain/entities/geo_point.dart';
import 'package:gallaemalae/domain/repositories/location_repository.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorLocationRepository implements LocationRepository {
  @override
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  @override
  Future<GeoPoint?> getLastKnownPosition() async {
    final position = await Geolocator.getLastKnownPosition();
    if (position == null) return null;
    return GeoPoint(latitude: position.latitude, longitude: position.longitude);
  }

  @override
  Future<GeoPoint> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 10),
      ),
    );
    return GeoPoint(latitude: position.latitude, longitude: position.longitude);
  }
}
