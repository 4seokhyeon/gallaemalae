// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnalysisViewState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisViewState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AnalysisViewState()';
}


}

/// @nodoc
class $AnalysisViewStateCopyWith<$Res>  {
$AnalysisViewStateCopyWith(AnalysisViewState _, $Res Function(AnalysisViewState) __);
}


/// Adds pattern-matching-related methods to [AnalysisViewState].
extension AnalysisViewStatePatterns on AnalysisViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AnalysisSelecting value)?  selecting,TResult Function( AnalysisResult value)?  result,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AnalysisSelecting() when selecting != null:
return selecting(_that);case AnalysisResult() when result != null:
return result(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AnalysisSelecting value)  selecting,required TResult Function( AnalysisResult value)  result,}){
final _that = this;
switch (_that) {
case AnalysisSelecting():
return selecting(_that);case AnalysisResult():
return result(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AnalysisSelecting value)?  selecting,TResult? Function( AnalysisResult value)?  result,}){
final _that = this;
switch (_that) {
case AnalysisSelecting() when selecting != null:
return selecting(_that);case AnalysisResult() when result != null:
return result(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<FestivalSummary> festivals)?  selecting,TResult Function( FestivalDetail festival,  FestivalAnalysis analysis,  DateTime visitDate)?  result,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AnalysisSelecting() when selecting != null:
return selecting(_that.festivals);case AnalysisResult() when result != null:
return result(_that.festival,_that.analysis,_that.visitDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<FestivalSummary> festivals)  selecting,required TResult Function( FestivalDetail festival,  FestivalAnalysis analysis,  DateTime visitDate)  result,}) {final _that = this;
switch (_that) {
case AnalysisSelecting():
return selecting(_that.festivals);case AnalysisResult():
return result(_that.festival,_that.analysis,_that.visitDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<FestivalSummary> festivals)?  selecting,TResult? Function( FestivalDetail festival,  FestivalAnalysis analysis,  DateTime visitDate)?  result,}) {final _that = this;
switch (_that) {
case AnalysisSelecting() when selecting != null:
return selecting(_that.festivals);case AnalysisResult() when result != null:
return result(_that.festival,_that.analysis,_that.visitDate);case _:
  return null;

}
}

}

/// @nodoc


class AnalysisSelecting implements AnalysisViewState {
  const AnalysisSelecting({required final  List<FestivalSummary> festivals}): _festivals = festivals;
  

 final  List<FestivalSummary> _festivals;
 List<FestivalSummary> get festivals {
  if (_festivals is EqualUnmodifiableListView) return _festivals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_festivals);
}


/// Create a copy of AnalysisViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisSelectingCopyWith<AnalysisSelecting> get copyWith => _$AnalysisSelectingCopyWithImpl<AnalysisSelecting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisSelecting&&const DeepCollectionEquality().equals(other._festivals, _festivals));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_festivals));

@override
String toString() {
  return 'AnalysisViewState.selecting(festivals: $festivals)';
}


}

/// @nodoc
abstract mixin class $AnalysisSelectingCopyWith<$Res> implements $AnalysisViewStateCopyWith<$Res> {
  factory $AnalysisSelectingCopyWith(AnalysisSelecting value, $Res Function(AnalysisSelecting) _then) = _$AnalysisSelectingCopyWithImpl;
@useResult
$Res call({
 List<FestivalSummary> festivals
});




}
/// @nodoc
class _$AnalysisSelectingCopyWithImpl<$Res>
    implements $AnalysisSelectingCopyWith<$Res> {
  _$AnalysisSelectingCopyWithImpl(this._self, this._then);

  final AnalysisSelecting _self;
  final $Res Function(AnalysisSelecting) _then;

/// Create a copy of AnalysisViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? festivals = null,}) {
  return _then(AnalysisSelecting(
festivals: null == festivals ? _self._festivals : festivals // ignore: cast_nullable_to_non_nullable
as List<FestivalSummary>,
  ));
}


}

/// @nodoc


class AnalysisResult implements AnalysisViewState {
  const AnalysisResult({required this.festival, required this.analysis, required this.visitDate});
  

 final  FestivalDetail festival;
 final  FestivalAnalysis analysis;
 final  DateTime visitDate;

/// Create a copy of AnalysisViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisResultCopyWith<AnalysisResult> get copyWith => _$AnalysisResultCopyWithImpl<AnalysisResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisResult&&(identical(other.festival, festival) || other.festival == festival)&&(identical(other.analysis, analysis) || other.analysis == analysis)&&(identical(other.visitDate, visitDate) || other.visitDate == visitDate));
}


@override
int get hashCode => Object.hash(runtimeType,festival,analysis,visitDate);

@override
String toString() {
  return 'AnalysisViewState.result(festival: $festival, analysis: $analysis, visitDate: $visitDate)';
}


}

/// @nodoc
abstract mixin class $AnalysisResultCopyWith<$Res> implements $AnalysisViewStateCopyWith<$Res> {
  factory $AnalysisResultCopyWith(AnalysisResult value, $Res Function(AnalysisResult) _then) = _$AnalysisResultCopyWithImpl;
@useResult
$Res call({
 FestivalDetail festival, FestivalAnalysis analysis, DateTime visitDate
});


$FestivalDetailCopyWith<$Res> get festival;$FestivalAnalysisCopyWith<$Res> get analysis;

}
/// @nodoc
class _$AnalysisResultCopyWithImpl<$Res>
    implements $AnalysisResultCopyWith<$Res> {
  _$AnalysisResultCopyWithImpl(this._self, this._then);

  final AnalysisResult _self;
  final $Res Function(AnalysisResult) _then;

/// Create a copy of AnalysisViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? festival = null,Object? analysis = null,Object? visitDate = null,}) {
  return _then(AnalysisResult(
festival: null == festival ? _self.festival : festival // ignore: cast_nullable_to_non_nullable
as FestivalDetail,analysis: null == analysis ? _self.analysis : analysis // ignore: cast_nullable_to_non_nullable
as FestivalAnalysis,visitDate: null == visitDate ? _self.visitDate : visitDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of AnalysisViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FestivalDetailCopyWith<$Res> get festival {
  
  return $FestivalDetailCopyWith<$Res>(_self.festival, (value) {
    return _then(_self.copyWith(festival: value));
  });
}/// Create a copy of AnalysisViewState
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
