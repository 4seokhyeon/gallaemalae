// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeViewState {

 String get summary; bool get isRefreshing;
/// Create a copy of HomeViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeViewStateCopyWith<HomeViewState> get copyWith => _$HomeViewStateCopyWithImpl<HomeViewState>(this as HomeViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeViewState&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing));
}


@override
int get hashCode => Object.hash(runtimeType,summary,isRefreshing);

@override
String toString() {
  return 'HomeViewState(summary: $summary, isRefreshing: $isRefreshing)';
}


}

/// @nodoc
abstract mixin class $HomeViewStateCopyWith<$Res>  {
  factory $HomeViewStateCopyWith(HomeViewState value, $Res Function(HomeViewState) _then) = _$HomeViewStateCopyWithImpl;
@useResult
$Res call({
 String summary, bool isRefreshing
});




}
/// @nodoc
class _$HomeViewStateCopyWithImpl<$Res>
    implements $HomeViewStateCopyWith<$Res> {
  _$HomeViewStateCopyWithImpl(this._self, this._then);

  final HomeViewState _self;
  final $Res Function(HomeViewState) _then;

/// Create a copy of HomeViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? isRefreshing = null,}) {
  return _then(_self.copyWith(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeViewState].
extension HomeViewStatePatterns on HomeViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeViewState value)  $default,){
final _that = this;
switch (_that) {
case _HomeViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeViewState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String summary,  bool isRefreshing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeViewState() when $default != null:
return $default(_that.summary,_that.isRefreshing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String summary,  bool isRefreshing)  $default,) {final _that = this;
switch (_that) {
case _HomeViewState():
return $default(_that.summary,_that.isRefreshing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String summary,  bool isRefreshing)?  $default,) {final _that = this;
switch (_that) {
case _HomeViewState() when $default != null:
return $default(_that.summary,_that.isRefreshing);case _:
  return null;

}
}

}

/// @nodoc


class _HomeViewState implements HomeViewState {
  const _HomeViewState({this.summary = '데이터를 분석하고 있어요', this.isRefreshing = false});
  

@override@JsonKey() final  String summary;
@override@JsonKey() final  bool isRefreshing;

/// Create a copy of HomeViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeViewStateCopyWith<_HomeViewState> get copyWith => __$HomeViewStateCopyWithImpl<_HomeViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeViewState&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing));
}


@override
int get hashCode => Object.hash(runtimeType,summary,isRefreshing);

@override
String toString() {
  return 'HomeViewState(summary: $summary, isRefreshing: $isRefreshing)';
}


}

/// @nodoc
abstract mixin class _$HomeViewStateCopyWith<$Res> implements $HomeViewStateCopyWith<$Res> {
  factory _$HomeViewStateCopyWith(_HomeViewState value, $Res Function(_HomeViewState) _then) = __$HomeViewStateCopyWithImpl;
@override @useResult
$Res call({
 String summary, bool isRefreshing
});




}
/// @nodoc
class __$HomeViewStateCopyWithImpl<$Res>
    implements _$HomeViewStateCopyWith<$Res> {
  __$HomeViewStateCopyWithImpl(this._self, this._then);

  final _HomeViewState _self;
  final $Res Function(_HomeViewState) _then;

/// Create a copy of HomeViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? isRefreshing = null,}) {
  return _then(_HomeViewState(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
