// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Visit {

 String get id; String get placeId; String get placeName; DateTime get visitedAt; int get crowdLevel;
/// Create a copy of Visit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitCopyWith<Visit> get copyWith => _$VisitCopyWithImpl<Visit>(this as Visit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Visit&&(identical(other.id, id) || other.id == id)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.visitedAt, visitedAt) || other.visitedAt == visitedAt)&&(identical(other.crowdLevel, crowdLevel) || other.crowdLevel == crowdLevel));
}


@override
int get hashCode => Object.hash(runtimeType,id,placeId,placeName,visitedAt,crowdLevel);

@override
String toString() {
  return 'Visit(id: $id, placeId: $placeId, placeName: $placeName, visitedAt: $visitedAt, crowdLevel: $crowdLevel)';
}


}

/// @nodoc
abstract mixin class $VisitCopyWith<$Res>  {
  factory $VisitCopyWith(Visit value, $Res Function(Visit) _then) = _$VisitCopyWithImpl;
@useResult
$Res call({
 String id, String placeId, String placeName, DateTime visitedAt, int crowdLevel
});




}
/// @nodoc
class _$VisitCopyWithImpl<$Res>
    implements $VisitCopyWith<$Res> {
  _$VisitCopyWithImpl(this._self, this._then);

  final Visit _self;
  final $Res Function(Visit) _then;

/// Create a copy of Visit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? placeId = null,Object? placeName = null,Object? visitedAt = null,Object? crowdLevel = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String,placeName: null == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String,visitedAt: null == visitedAt ? _self.visitedAt : visitedAt // ignore: cast_nullable_to_non_nullable
as DateTime,crowdLevel: null == crowdLevel ? _self.crowdLevel : crowdLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Visit].
extension VisitPatterns on Visit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Visit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Visit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Visit value)  $default,){
final _that = this;
switch (_that) {
case _Visit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Visit value)?  $default,){
final _that = this;
switch (_that) {
case _Visit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String placeId,  String placeName,  DateTime visitedAt,  int crowdLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Visit() when $default != null:
return $default(_that.id,_that.placeId,_that.placeName,_that.visitedAt,_that.crowdLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String placeId,  String placeName,  DateTime visitedAt,  int crowdLevel)  $default,) {final _that = this;
switch (_that) {
case _Visit():
return $default(_that.id,_that.placeId,_that.placeName,_that.visitedAt,_that.crowdLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String placeId,  String placeName,  DateTime visitedAt,  int crowdLevel)?  $default,) {final _that = this;
switch (_that) {
case _Visit() when $default != null:
return $default(_that.id,_that.placeId,_that.placeName,_that.visitedAt,_that.crowdLevel);case _:
  return null;

}
}

}

/// @nodoc


class _Visit implements Visit {
  const _Visit({required this.id, required this.placeId, required this.placeName, required this.visitedAt, required this.crowdLevel});
  

@override final  String id;
@override final  String placeId;
@override final  String placeName;
@override final  DateTime visitedAt;
@override final  int crowdLevel;

/// Create a copy of Visit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitCopyWith<_Visit> get copyWith => __$VisitCopyWithImpl<_Visit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Visit&&(identical(other.id, id) || other.id == id)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.visitedAt, visitedAt) || other.visitedAt == visitedAt)&&(identical(other.crowdLevel, crowdLevel) || other.crowdLevel == crowdLevel));
}


@override
int get hashCode => Object.hash(runtimeType,id,placeId,placeName,visitedAt,crowdLevel);

@override
String toString() {
  return 'Visit(id: $id, placeId: $placeId, placeName: $placeName, visitedAt: $visitedAt, crowdLevel: $crowdLevel)';
}


}

/// @nodoc
abstract mixin class _$VisitCopyWith<$Res> implements $VisitCopyWith<$Res> {
  factory _$VisitCopyWith(_Visit value, $Res Function(_Visit) _then) = __$VisitCopyWithImpl;
@override @useResult
$Res call({
 String id, String placeId, String placeName, DateTime visitedAt, int crowdLevel
});




}
/// @nodoc
class __$VisitCopyWithImpl<$Res>
    implements _$VisitCopyWith<$Res> {
  __$VisitCopyWithImpl(this._self, this._then);

  final _Visit _self;
  final $Res Function(_Visit) _then;

/// Create a copy of Visit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? placeId = null,Object? placeName = null,Object? visitedAt = null,Object? crowdLevel = null,}) {
  return _then(_Visit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String,placeName: null == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String,visitedAt: null == visitedAt ? _self.visitedAt : visitedAt // ignore: cast_nullable_to_non_nullable
as DateTime,crowdLevel: null == crowdLevel ? _self.crowdLevel : crowdLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
