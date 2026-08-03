// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoritePlace {

 String get placeId; String get name; double get latitude; double get longitude; DateTime get createdAt;
/// Create a copy of FavoritePlace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoritePlaceCopyWith<FavoritePlace> get copyWith => _$FavoritePlaceCopyWithImpl<FavoritePlace>(this as FavoritePlace, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoritePlace&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,placeId,name,latitude,longitude,createdAt);

@override
String toString() {
  return 'FavoritePlace(placeId: $placeId, name: $name, latitude: $latitude, longitude: $longitude, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FavoritePlaceCopyWith<$Res>  {
  factory $FavoritePlaceCopyWith(FavoritePlace value, $Res Function(FavoritePlace) _then) = _$FavoritePlaceCopyWithImpl;
@useResult
$Res call({
 String placeId, String name, double latitude, double longitude, DateTime createdAt
});




}
/// @nodoc
class _$FavoritePlaceCopyWithImpl<$Res>
    implements $FavoritePlaceCopyWith<$Res> {
  _$FavoritePlaceCopyWithImpl(this._self, this._then);

  final FavoritePlace _self;
  final $Res Function(FavoritePlace) _then;

/// Create a copy of FavoritePlace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? placeId = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoritePlace].
extension FavoritePlacePatterns on FavoritePlace {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoritePlace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoritePlace() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoritePlace value)  $default,){
final _that = this;
switch (_that) {
case _FavoritePlace():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoritePlace value)?  $default,){
final _that = this;
switch (_that) {
case _FavoritePlace() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String placeId,  String name,  double latitude,  double longitude,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoritePlace() when $default != null:
return $default(_that.placeId,_that.name,_that.latitude,_that.longitude,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String placeId,  String name,  double latitude,  double longitude,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _FavoritePlace():
return $default(_that.placeId,_that.name,_that.latitude,_that.longitude,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String placeId,  String name,  double latitude,  double longitude,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FavoritePlace() when $default != null:
return $default(_that.placeId,_that.name,_that.latitude,_that.longitude,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _FavoritePlace implements FavoritePlace {
  const _FavoritePlace({required this.placeId, required this.name, required this.latitude, required this.longitude, required this.createdAt});
  

@override final  String placeId;
@override final  String name;
@override final  double latitude;
@override final  double longitude;
@override final  DateTime createdAt;

/// Create a copy of FavoritePlace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoritePlaceCopyWith<_FavoritePlace> get copyWith => __$FavoritePlaceCopyWithImpl<_FavoritePlace>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoritePlace&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,placeId,name,latitude,longitude,createdAt);

@override
String toString() {
  return 'FavoritePlace(placeId: $placeId, name: $name, latitude: $latitude, longitude: $longitude, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FavoritePlaceCopyWith<$Res> implements $FavoritePlaceCopyWith<$Res> {
  factory _$FavoritePlaceCopyWith(_FavoritePlace value, $Res Function(_FavoritePlace) _then) = __$FavoritePlaceCopyWithImpl;
@override @useResult
$Res call({
 String placeId, String name, double latitude, double longitude, DateTime createdAt
});




}
/// @nodoc
class __$FavoritePlaceCopyWithImpl<$Res>
    implements _$FavoritePlaceCopyWith<$Res> {
  __$FavoritePlaceCopyWithImpl(this._self, this._then);

  final _FavoritePlace _self;
  final $Res Function(_FavoritePlace) _then;

/// Create a copy of FavoritePlace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? placeId = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? createdAt = null,}) {
  return _then(_FavoritePlace(
placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
