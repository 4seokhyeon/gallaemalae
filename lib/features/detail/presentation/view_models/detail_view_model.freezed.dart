// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DetailViewState {

 FestivalDetail get festival; FestivalAnalysis get analysis;
/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DetailViewStateCopyWith<DetailViewState> get copyWith => _$DetailViewStateCopyWithImpl<DetailViewState>(this as DetailViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DetailViewState&&(identical(other.festival, festival) || other.festival == festival)&&(identical(other.analysis, analysis) || other.analysis == analysis));
}


@override
int get hashCode => Object.hash(runtimeType,festival,analysis);

@override
String toString() {
  return 'DetailViewState(festival: $festival, analysis: $analysis)';
}


}

/// @nodoc
abstract mixin class $DetailViewStateCopyWith<$Res>  {
  factory $DetailViewStateCopyWith(DetailViewState value, $Res Function(DetailViewState) _then) = _$DetailViewStateCopyWithImpl;
@useResult
$Res call({
 FestivalDetail festival, FestivalAnalysis analysis
});


$FestivalDetailCopyWith<$Res> get festival;$FestivalAnalysisCopyWith<$Res> get analysis;

}
/// @nodoc
class _$DetailViewStateCopyWithImpl<$Res>
    implements $DetailViewStateCopyWith<$Res> {
  _$DetailViewStateCopyWithImpl(this._self, this._then);

  final DetailViewState _self;
  final $Res Function(DetailViewState) _then;

/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? festival = null,Object? analysis = null,}) {
  return _then(_self.copyWith(
festival: null == festival ? _self.festival : festival // ignore: cast_nullable_to_non_nullable
as FestivalDetail,analysis: null == analysis ? _self.analysis : analysis // ignore: cast_nullable_to_non_nullable
as FestivalAnalysis,
  ));
}
/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FestivalDetailCopyWith<$Res> get festival {
  
  return $FestivalDetailCopyWith<$Res>(_self.festival, (value) {
    return _then(_self.copyWith(festival: value));
  });
}/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FestivalAnalysisCopyWith<$Res> get analysis {
  
  return $FestivalAnalysisCopyWith<$Res>(_self.analysis, (value) {
    return _then(_self.copyWith(analysis: value));
  });
}
}


/// Adds pattern-matching-related methods to [DetailViewState].
extension DetailViewStatePatterns on DetailViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DetailViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DetailViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DetailViewState value)  $default,){
final _that = this;
switch (_that) {
case _DetailViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DetailViewState value)?  $default,){
final _that = this;
switch (_that) {
case _DetailViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FestivalDetail festival,  FestivalAnalysis analysis)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DetailViewState() when $default != null:
return $default(_that.festival,_that.analysis);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FestivalDetail festival,  FestivalAnalysis analysis)  $default,) {final _that = this;
switch (_that) {
case _DetailViewState():
return $default(_that.festival,_that.analysis);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FestivalDetail festival,  FestivalAnalysis analysis)?  $default,) {final _that = this;
switch (_that) {
case _DetailViewState() when $default != null:
return $default(_that.festival,_that.analysis);case _:
  return null;

}
}

}

/// @nodoc


class _DetailViewState implements DetailViewState {
  const _DetailViewState({required this.festival, required this.analysis});
  

@override final  FestivalDetail festival;
@override final  FestivalAnalysis analysis;

/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailViewStateCopyWith<_DetailViewState> get copyWith => __$DetailViewStateCopyWithImpl<_DetailViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailViewState&&(identical(other.festival, festival) || other.festival == festival)&&(identical(other.analysis, analysis) || other.analysis == analysis));
}


@override
int get hashCode => Object.hash(runtimeType,festival,analysis);

@override
String toString() {
  return 'DetailViewState(festival: $festival, analysis: $analysis)';
}


}

/// @nodoc
abstract mixin class _$DetailViewStateCopyWith<$Res> implements $DetailViewStateCopyWith<$Res> {
  factory _$DetailViewStateCopyWith(_DetailViewState value, $Res Function(_DetailViewState) _then) = __$DetailViewStateCopyWithImpl;
@override @useResult
$Res call({
 FestivalDetail festival, FestivalAnalysis analysis
});


@override $FestivalDetailCopyWith<$Res> get festival;@override $FestivalAnalysisCopyWith<$Res> get analysis;

}
/// @nodoc
class __$DetailViewStateCopyWithImpl<$Res>
    implements _$DetailViewStateCopyWith<$Res> {
  __$DetailViewStateCopyWithImpl(this._self, this._then);

  final _DetailViewState _self;
  final $Res Function(_DetailViewState) _then;

/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? festival = null,Object? analysis = null,}) {
  return _then(_DetailViewState(
festival: null == festival ? _self.festival : festival // ignore: cast_nullable_to_non_nullable
as FestivalDetail,analysis: null == analysis ? _self.analysis : analysis // ignore: cast_nullable_to_non_nullable
as FestivalAnalysis,
  ));
}

/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FestivalDetailCopyWith<$Res> get festival {
  
  return $FestivalDetailCopyWith<$Res>(_self.festival, (value) {
    return _then(_self.copyWith(festival: value));
  });
}/// Create a copy of DetailViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FestivalAnalysisCopyWith<$Res> get analysis {
  
  return $FestivalAnalysisCopyWith<$Res>(_self.analysis, (value) {
    return _then(_self.copyWith(analysis: value));
  });
}
}

// dart format on
