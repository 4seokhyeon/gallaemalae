import 'package:gallaemalae/domain/entities/geo_point.dart';

abstract interface class LocationRepository {
  Future<bool> isServiceEnabled();
  Future<GeoPoint?> getLastKnownPosition();
  Future<GeoPoint> getCurrentPosition();
}
