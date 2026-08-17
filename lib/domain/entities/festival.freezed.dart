// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'festival.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FestivalSummary {

 int get id; String get title; String get regionCode; DateTime get startDate; DateTime get endDate; FestivalCategory get category; String get address; double get latitude; double get longitude; String get primaryImageUrl;
/// Create a copy of FestivalSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestivalSummaryCopyWith<FestivalSummary> get copyWith => _$FestivalSummaryCopyWithImpl<FestivalSummary>(this as FestivalSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FestivalSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.regionCode, regionCode) || other.regionCode == regionCode)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.category, category) || other.category == category)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.primaryImageUrl, primaryImageUrl) || other.primaryImageUrl == primaryImageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,regionCode,startDate,endDate,category,address,latitude,longitude,primaryImageUrl);

@override
String toString() {
  return 'FestivalSummary(id: $id, title: $title, regionCode: $regionCode, startDate: $startDate, endDate: $endDate, category: $category, address: $address, latitude: $latitude, longitude: $longitude, primaryImageUrl: $primaryImageUrl)';
}


}

/// @nodoc
abstract mixin class $FestivalSummaryCopyWith<$Res>  {
  factory $FestivalSummaryCopyWith(FestivalSummary value, $Res Function(FestivalSummary) _then) = _$FestivalSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String title, String regionCode, DateTime startDate, DateTime endDate, FestivalCategory category, String address, double latitude, double longitude, String primaryImageUrl
});




}
/// @nodoc
class _$FestivalSummaryCopyWithImpl<$Res>
    implements $FestivalSummaryCopyWith<$Res> {
  _$FestivalSummaryCopyWithImpl(this._self, this._then);

  final FestivalSummary _self;
  final $Res Function(FestivalSummary) _then;

/// Create a copy of FestivalSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? regionCode = null,Object? startDate = null,Object? endDate = null,Object? category = null,Object? address = null,Object? latitude = null,Object? longitude = null,Object? primaryImageUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,regionCode: null == regionCode ? _self.regionCode : regionCode // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FestivalCategory,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,primaryImageUrl: null == primaryImageUrl ? _self.primaryImageUrl : primaryImageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FestivalSummary].
extension FestivalSummaryPatterns on FestivalSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FestivalSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FestivalSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FestivalSummary value)  $default,){
final _that = this;
switch (_that) {
case _FestivalSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FestivalSummary value)?  $default,){
final _that = this;
switch (_that) {
case _FestivalSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String regionCode,  DateTime startDate,  DateTime endDate,  FestivalCategory category,  String address,  double latitude,  double longitude,  String primaryImageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FestivalSummary() when $default != null:
return $default(_that.id,_that.title,_that.regionCode,_that.startDate,_that.endDate,_that.category,_that.address,_that.latitude,_that.longitude,_that.primaryImageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String regionCode,  DateTime startDate,  DateTime endDate,  FestivalCategory category,  String address,  double latitude,  double longitude,  String primaryImageUrl)  $default,) {final _that = this;
switch (_that) {
case _FestivalSummary():
return $default(_that.id,_that.title,_that.regionCode,_that.startDate,_that.endDate,_that.category,_that.address,_that.latitude,_that.longitude,_that.primaryImageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String regionCode,  DateTime startDate,  DateTime endDate,  FestivalCategory category,  String address,  double latitude,  double longitude,  String primaryImageUrl)?  $default,) {final _that = this;
switch (_that) {
case _FestivalSummary() when $default != null:
return $default(_that.id,_that.title,_that.regionCode,_that.startDate,_that.endDate,_that.category,_that.address,_that.latitude,_that.longitude,_that.primaryImageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _FestivalSummary implements FestivalSummary {
  const _FestivalSummary({required this.id, required this.title, required this.regionCode, required this.startDate, required this.endDate, required this.category, required this.address, required this.latitude, required this.longitude, required this.primaryImageUrl});
  

@override final  int id;
@override final  String title;
@override final  String regionCode;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  FestivalCategory category;
@override final  String address;
@override final  double latitude;
@override final  double longitude;
@override final  String primaryImageUrl;

/// Create a copy of FestivalSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestivalSummaryCopyWith<_FestivalSummary> get copyWith => __$FestivalSummaryCopyWithImpl<_FestivalSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FestivalSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.regionCode, regionCode) || other.regionCode == regionCode)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.category, category) || other.category == category)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.primaryImageUrl, primaryImageUrl) || other.primaryImageUrl == primaryImageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,regionCode,startDate,endDate,category,address,latitude,longitude,primaryImageUrl);

@override
String toString() {
  return 'FestivalSummary(id: $id, title: $title, regionCode: $regionCode, startDate: $startDate, endDate: $endDate, category: $category, address: $address, latitude: $latitude, longitude: $longitude, primaryImageUrl: $primaryImageUrl)';
}


}

/// @nodoc
abstract mixin class _$FestivalSummaryCopyWith<$Res> implements $FestivalSummaryCopyWith<$Res> {
  factory _$FestivalSummaryCopyWith(_FestivalSummary value, $Res Function(_FestivalSummary) _then) = __$FestivalSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String regionCode, DateTime startDate, DateTime endDate, FestivalCategory category, String address, double latitude, double longitude, String primaryImageUrl
});




}
/// @nodoc
class __$FestivalSummaryCopyWithImpl<$Res>
    implements _$FestivalSummaryCopyWith<$Res> {
  __$FestivalSummaryCopyWithImpl(this._self, this._then);

  final _FestivalSummary _self;
  final $Res Function(_FestivalSummary) _then;

/// Create a copy of FestivalSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? regionCode = null,Object? startDate = null,Object? endDate = null,Object? category = null,Object? address = null,Object? latitude = null,Object? longitude = null,Object? primaryImageUrl = null,}) {
  return _then(_FestivalSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,regionCode: null == regionCode ? _self.regionCode : regionCode // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FestivalCategory,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,primaryImageUrl: null == primaryImageUrl ? _self.primaryImageUrl : primaryImageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$FestivalPage {

 List<FestivalSummary> get items; int get page; int get size; int get totalElements; int get totalPages;
/// Create a copy of FestivalPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestivalPageCopyWith<FestivalPage> get copyWith => _$FestivalPageCopyWithImpl<FestivalPage>(this as FestivalPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FestivalPage&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.page, page) || other.page == page)&&(identical(other.size, size) || other.size == size)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),page,size,totalElements,totalPages);

@override
String toString() {
  return 'FestivalPage(items: $items, page: $page, size: $size, totalElements: $totalElements, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $FestivalPageCopyWith<$Res>  {
  factory $FestivalPageCopyWith(FestivalPage value, $Res Function(FestivalPage) _then) = _$FestivalPageCopyWithImpl;
@useResult
$Res call({
 List<FestivalSummary> items, int page, int size, int totalElements, int totalPages
});




}
/// @nodoc
class _$FestivalPageCopyWithImpl<$Res>
    implements $FestivalPageCopyWith<$Res> {
  _$FestivalPageCopyWithImpl(this._self, this._then);

  final FestivalPage _self;
  final $Res Function(FestivalPage) _then;

/// Create a copy of FestivalPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? page = null,Object? size = null,Object? totalElements = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<FestivalSummary>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FestivalPage].
extension FestivalPagePatterns on FestivalPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FestivalPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FestivalPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FestivalPage value)  $default,){
final _that = this;
switch (_that) {
case _FestivalPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FestivalPage value)?  $default,){
final _that = this;
switch (_that) {
case _FestivalPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FestivalSummary> items,  int page,  int size,  int totalElements,  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FestivalPage() when $default != null:
return $default(_that.items,_that.page,_that.size,_that.totalElements,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FestivalSummary> items,  int page,  int size,  int totalElements,  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _FestivalPage():
return $default(_that.items,_that.page,_that.size,_that.totalElements,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FestivalSummary> items,  int page,  int size,  int totalElements,  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _FestivalPage() when $default != null:
return $default(_that.items,_that.page,_that.size,_that.totalElements,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc


class _FestivalPage implements FestivalPage {
  const _FestivalPage({required final  List<FestivalSummary> items, required this.page, required this.size, required this.totalElements, required this.totalPages}): _items = items;
  

 final  List<FestivalSummary> _items;
@override List<FestivalSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
@override final  int size;
@override final  int totalElements;
@override final  int totalPages;

/// Create a copy of FestivalPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestivalPageCopyWith<_FestivalPage> get copyWith => __$FestivalPageCopyWithImpl<_FestivalPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FestivalPage&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.size, size) || other.size == size)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,size,totalElements,totalPages);

@override
String toString() {
  return 'FestivalPage(items: $items, page: $page, size: $size, totalElements: $totalElements, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$FestivalPageCopyWith<$Res> implements $FestivalPageCopyWith<$Res> {
  factory _$FestivalPageCopyWith(_FestivalPage value, $Res Function(_FestivalPage) _then) = __$FestivalPageCopyWithImpl;
@override @useResult
$Res call({
 List<FestivalSummary> items, int page, int size, int totalElements, int totalPages
});




}
/// @nodoc
class __$FestivalPageCopyWithImpl<$Res>
    implements _$FestivalPageCopyWith<$Res> {
  __$FestivalPageCopyWithImpl(this._self, this._then);

  final _FestivalPage _self;
  final $Res Function(_FestivalPage) _then;

/// Create a copy of FestivalPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? size = null,Object? totalElements = null,Object? totalPages = null,}) {
  return _then(_FestivalPage(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<FestivalSummary>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$FestivalDetail {

 int get id; String get title; String get regionCode; DateTime get startDate; DateTime get endDate; FestivalCategory get category; String get externalSource; String get address; double get latitude; double get longitude; String get primaryImageUrl;
/// Create a copy of FestivalDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestivalDetailCopyWith<FestivalDetail> get copyWith => _$FestivalDetailCopyWithImpl<FestivalDetail>(this as FestivalDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FestivalDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.regionCode, regionCode) || other.regionCode == regionCode)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.category, category) || other.category == category)&&(identical(other.externalSource, externalSource) || other.externalSource == externalSource)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.primaryImageUrl, primaryImageUrl) || other.primaryImageUrl == primaryImageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,regionCode,startDate,endDate,category,externalSource,address,latitude,longitude,primaryImageUrl);

@override
String toString() {
  return 'FestivalDetail(id: $id, title: $title, regionCode: $regionCode, startDate: $startDate, endDate: $endDate, category: $category, externalSource: $externalSource, address: $address, latitude: $latitude, longitude: $longitude, primaryImageUrl: $primaryImageUrl)';
}


}

/// @nodoc
abstract mixin class $FestivalDetailCopyWith<$Res>  {
  factory $FestivalDetailCopyWith(FestivalDetail value, $Res Function(FestivalDetail) _then) = _$FestivalDetailCopyWithImpl;
@useResult
$Res call({
 int id, String title, String regionCode, DateTime startDate, DateTime endDate, FestivalCategory category, String externalSource, String address, double latitude, double longitude, String primaryImageUrl
});




}
/// @nodoc
class _$FestivalDetailCopyWithImpl<$Res>
    implements $FestivalDetailCopyWith<$Res> {
  _$FestivalDetailCopyWithImpl(this._self, this._then);

  final FestivalDetail _self;
  final $Res Function(FestivalDetail) _then;

/// Create a copy of FestivalDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? regionCode = null,Object? startDate = null,Object? endDate = null,Object? category = null,Object? externalSource = null,Object? address = null,Object? latitude = null,Object? longitude = null,Object? primaryImageUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,regionCode: null == regionCode ? _self.regionCode : regionCode // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FestivalCategory,externalSource: null == externalSource ? _self.externalSource : externalSource // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,primaryImageUrl: null == primaryImageUrl ? _self.primaryImageUrl : primaryImageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FestivalDetail].
extension FestivalDetailPatterns on FestivalDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FestivalDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FestivalDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FestivalDetail value)  $default,){
final _that = this;
switch (_that) {
case _FestivalDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FestivalDetail value)?  $default,){
final _that = this;
switch (_that) {
case _FestivalDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String regionCode,  DateTime startDate,  DateTime endDate,  FestivalCategory category,  String externalSource,  String address,  double latitude,  double longitude,  String primaryImageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FestivalDetail() when $default != null:
return $default(_that.id,_that.title,_that.regionCode,_that.startDate,_that.endDate,_that.category,_that.externalSource,_that.address,_that.latitude,_that.longitude,_that.primaryImageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String regionCode,  DateTime startDate,  DateTime endDate,  FestivalCategory category,  String externalSource,  String address,  double latitude,  double longitude,  String primaryImageUrl)  $default,) {final _that = this;
switch (_that) {
case _FestivalDetail():
return $default(_that.id,_that.title,_that.regionCode,_that.startDate,_that.endDate,_that.category,_that.externalSource,_that.address,_that.latitude,_that.longitude,_that.primaryImageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String regionCode,  DateTime startDate,  DateTime endDate,  FestivalCategory category,  String externalSource,  String address,  double latitude,  double longitude,  String primaryImageUrl)?  $default,) {final _that = this;
switch (_that) {
case _FestivalDetail() when $default != null:
return $default(_that.id,_that.title,_that.regionCode,_that.startDate,_that.endDate,_that.category,_that.externalSource,_that.address,_that.latitude,_that.longitude,_that.primaryImageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _FestivalDetail implements FestivalDetail {
  const _FestivalDetail({required this.id, required this.title, required this.regionCode, required this.startDate, required this.endDate, required this.category, required this.externalSource, required this.address, required this.latitude, required this.longitude, required this.primaryImageUrl});
  

@override final  int id;
@override final  String title;
@override final  String regionCode;
@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  FestivalCategory category;
@override final  String externalSource;
@override final  String address;
@override final  double latitude;
@override final  double longitude;
@override final  String primaryImageUrl;

/// Create a copy of FestivalDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestivalDetailCopyWith<_FestivalDetail> get copyWith => __$FestivalDetailCopyWithImpl<_FestivalDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FestivalDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.regionCode, regionCode) || other.regionCode == regionCode)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.category, category) || other.category == category)&&(identical(other.externalSource, externalSource) || other.externalSource == externalSource)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.primaryImageUrl, primaryImageUrl) || other.primaryImageUrl == primaryImageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,regionCode,startDate,endDate,category,externalSource,address,latitude,longitude,primaryImageUrl);

@override
String toString() {
  return 'FestivalDetail(id: $id, title: $title, regionCode: $regionCode, startDate: $startDate, endDate: $endDate, category: $category, externalSource: $externalSource, address: $address, latitude: $latitude, longitude: $longitude, primaryImageUrl: $primaryImageUrl)';
}


}

/// @nodoc
abstract mixin class _$FestivalDetailCopyWith<$Res> implements $FestivalDetailCopyWith<$Res> {
  factory _$FestivalDetailCopyWith(_FestivalDetail value, $Res Function(_FestivalDetail) _then) = __$FestivalDetailCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String regionCode, DateTime startDate, DateTime endDate, FestivalCategory category, String externalSource, String address, double latitude, double longitude, String primaryImageUrl
});




}
/// @nodoc
class __$FestivalDetailCopyWithImpl<$Res>
    implements _$FestivalDetailCopyWith<$Res> {
  __$FestivalDetailCopyWithImpl(this._self, this._then);

  final _FestivalDetail _self;
  final $Res Function(_FestivalDetail) _then;

/// Create a copy of FestivalDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? regionCode = null,Object? startDate = null,Object? endDate = null,Object? category = null,Object? externalSource = null,Object? address = null,Object? latitude = null,Object? longitude = null,Object? primaryImageUrl = null,}) {
  return _then(_FestivalDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,regionCode: null == regionCode ? _self.regionCode : regionCode // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as FestivalCategory,externalSource: null == externalSource ? _self.externalSource : externalSource // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,primaryImageUrl: null == primaryImageUrl ? _self.primaryImageUrl : primaryImageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$CrowdPrediction {

 int get score; CrowdLevel get level;
/// Create a copy of CrowdPrediction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CrowdPredictionCopyWith<CrowdPrediction> get copyWith => _$CrowdPredictionCopyWithImpl<CrowdPrediction>(this as CrowdPrediction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CrowdPrediction&&(identical(other.score, score) || other.score == score)&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,score,level);

@override
String toString() {
  return 'CrowdPrediction(score: $score, level: $level)';
}


}

/// @nodoc
abstract mixin class $CrowdPredictionCopyWith<$Res>  {
  factory $CrowdPredictionCopyWith(CrowdPrediction value, $Res Function(CrowdPrediction) _then) = _$CrowdPredictionCopyWithImpl;
@useResult
$Res call({
 int score, CrowdLevel level
});




}
/// @nodoc
class _$CrowdPredictionCopyWithImpl<$Res>
    implements $CrowdPredictionCopyWith<$Res> {
  _$CrowdPredictionCopyWithImpl(this._self, this._then);

  final CrowdPrediction _self;
  final $Res Function(CrowdPrediction) _then;

/// Create a copy of CrowdPrediction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? level = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CrowdLevel,
  ));
}

}


/// Adds pattern-matching-related methods to [CrowdPrediction].
extension CrowdPredictionPatterns on CrowdPrediction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CrowdPrediction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CrowdPrediction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CrowdPrediction value)  $default,){
final _that = this;
switch (_that) {
case _CrowdPrediction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CrowdPrediction value)?  $default,){
final _that = this;
switch (_that) {
case _CrowdPrediction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int score,  CrowdLevel level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CrowdPrediction() when $default != null:
return $default(_that.score,_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int score,  CrowdLevel level)  $default,) {final _that = this;
switch (_that) {
case _CrowdPrediction():
return $default(_that.score,_that.level);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int score,  CrowdLevel level)?  $default,) {final _that = this;
switch (_that) {
case _CrowdPrediction() when $default != null:
return $default(_that.score,_that.level);case _:
  return null;

}
}

}

/// @nodoc


class _CrowdPrediction implements CrowdPrediction {
  const _CrowdPrediction({required this.score, required this.level});
  

@override final  int score;
@override final  CrowdLevel level;

/// Create a copy of CrowdPrediction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CrowdPredictionCopyWith<_CrowdPrediction> get copyWith => __$CrowdPredictionCopyWithImpl<_CrowdPrediction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CrowdPrediction&&(identical(other.score, score) || other.score == score)&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,score,level);

@override
String toString() {
  return 'CrowdPrediction(score: $score, level: $level)';
}


}

/// @nodoc
abstract mixin class _$CrowdPredictionCopyWith<$Res> implements $CrowdPredictionCopyWith<$Res> {
  factory _$CrowdPredictionCopyWith(_CrowdPrediction value, $Res Function(_CrowdPrediction) _then) = __$CrowdPredictionCopyWithImpl;
@override @useResult
$Res call({
 int score, CrowdLevel level
});




}
/// @nodoc
class __$CrowdPredictionCopyWithImpl<$Res>
    implements _$CrowdPredictionCopyWith<$Res> {
  __$CrowdPredictionCopyWithImpl(this._self, this._then);

  final _CrowdPrediction _self;
  final $Res Function(_CrowdPrediction) _then;

/// Create a copy of CrowdPrediction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? level = null,}) {
  return _then(_CrowdPrediction(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CrowdLevel,
  ));
}


}

/// @nodoc
mixin _$TimeSlotPrediction {

 DayPeriod get period; String get startTime; String get endTime; int get score; CrowdLevel get level;
/// Create a copy of TimeSlotPrediction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSlotPredictionCopyWith<TimeSlotPrediction> get copyWith => _$TimeSlotPredictionCopyWithImpl<TimeSlotPrediction>(this as TimeSlotPrediction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSlotPrediction&&(identical(other.period, period) || other.period == period)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.score, score) || other.score == score)&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,period,startTime,endTime,score,level);

@override
String toString() {
  return 'TimeSlotPrediction(period: $period, startTime: $startTime, endTime: $endTime, score: $score, level: $level)';
}


}

/// @nodoc
abstract mixin class $TimeSlotPredictionCopyWith<$Res>  {
  factory $TimeSlotPredictionCopyWith(TimeSlotPrediction value, $Res Function(TimeSlotPrediction) _then) = _$TimeSlotPredictionCopyWithImpl;
@useResult
$Res call({
 DayPeriod period, String startTime, String endTime, int score, CrowdLevel level
});




}
/// @nodoc
class _$TimeSlotPredictionCopyWithImpl<$Res>
    implements $TimeSlotPredictionCopyWith<$Res> {
  _$TimeSlotPredictionCopyWithImpl(this._self, this._then);

  final TimeSlotPrediction _self;
  final $Res Function(TimeSlotPrediction) _then;

/// Create a copy of TimeSlotPrediction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? startTime = null,Object? endTime = null,Object? score = null,Object? level = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as DayPeriod,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CrowdLevel,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeSlotPrediction].
extension TimeSlotPredictionPatterns on TimeSlotPrediction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSlotPrediction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSlotPrediction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSlotPrediction value)  $default,){
final _that = this;
switch (_that) {
case _TimeSlotPrediction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSlotPrediction value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSlotPrediction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DayPeriod period,  String startTime,  String endTime,  int score,  CrowdLevel level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSlotPrediction() when $default != null:
return $default(_that.period,_that.startTime,_that.endTime,_that.score,_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DayPeriod period,  String startTime,  String endTime,  int score,  CrowdLevel level)  $default,) {final _that = this;
switch (_that) {
case _TimeSlotPrediction():
return $default(_that.period,_that.startTime,_that.endTime,_that.score,_that.level);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DayPeriod period,  String startTime,  String endTime,  int score,  CrowdLevel level)?  $default,) {final _that = this;
switch (_that) {
case _TimeSlotPrediction() when $default != null:
return $default(_that.period,_that.startTime,_that.endTime,_that.score,_that.level);case _:
  return null;

}
}

}

/// @nodoc


class _TimeSlotPrediction implements TimeSlotPrediction {
  const _TimeSlotPrediction({required this.period, required this.startTime, required this.endTime, required this.score, required this.level});
  

@override final  DayPeriod period;
@override final  String startTime;
@override final  String endTime;
@override final  int score;
@override final  CrowdLevel level;

/// Create a copy of TimeSlotPrediction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSlotPredictionCopyWith<_TimeSlotPrediction> get copyWith => __$TimeSlotPredictionCopyWithImpl<_TimeSlotPrediction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSlotPrediction&&(identical(other.period, period) || other.period == period)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.score, score) || other.score == score)&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,period,startTime,endTime,score,level);

@override
String toString() {
  return 'TimeSlotPrediction(period: $period, startTime: $startTime, endTime: $endTime, score: $score, level: $level)';
}


}

/// @nodoc
abstract mixin class _$TimeSlotPredictionCopyWith<$Res> implements $TimeSlotPredictionCopyWith<$Res> {
  factory _$TimeSlotPredictionCopyWith(_TimeSlotPrediction value, $Res Function(_TimeSlotPrediction) _then) = __$TimeSlotPredictionCopyWithImpl;
@override @useResult
$Res call({
 DayPeriod period, String startTime, String endTime, int score, CrowdLevel level
});




}
/// @nodoc
class __$TimeSlotPredictionCopyWithImpl<$Res>
    implements _$TimeSlotPredictionCopyWith<$Res> {
  __$TimeSlotPredictionCopyWithImpl(this._self, this._then);

  final _TimeSlotPrediction _self;
  final $Res Function(_TimeSlotPrediction) _then;

/// Create a copy of TimeSlotPrediction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? startTime = null,Object? endTime = null,Object? score = null,Object? level = null,}) {
  return _then(_TimeSlotPrediction(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as DayPeriod,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CrowdLevel,
  ));
}


}

/// @nodoc
mixin _$FestivalAnalysis {

 int get festivalId; DateTime get predictedFor; CrowdPrediction get overall; List<TimeSlotPrediction> get timeSlots; DayPeriod get recommendedPeriod; DayPeriod get busiestPeriod; double get confidence; DateTime get basedAt; List<String> get factors; DateTime get dataUpdatedAt; DataFreshness get freshness;
/// Create a copy of FestivalAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FestivalAnalysisCopyWith<FestivalAnalysis> get copyWith => _$FestivalAnalysisCopyWithImpl<FestivalAnalysis>(this as FestivalAnalysis, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FestivalAnalysis&&(identical(other.festivalId, festivalId) || other.festivalId == festivalId)&&(identical(other.predictedFor, predictedFor) || other.predictedFor == predictedFor)&&(identical(other.overall, overall) || other.overall == overall)&&const DeepCollectionEquality().equals(other.timeSlots, timeSlots)&&(identical(other.recommendedPeriod, recommendedPeriod) || other.recommendedPeriod == recommendedPeriod)&&(identical(other.busiestPeriod, busiestPeriod) || other.busiestPeriod == busiestPeriod)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.basedAt, basedAt) || other.basedAt == basedAt)&&const DeepCollectionEquality().equals(other.factors, factors)&&(identical(other.dataUpdatedAt, dataUpdatedAt) || other.dataUpdatedAt == dataUpdatedAt)&&(identical(other.freshness, freshness) || other.freshness == freshness));
}


@override
int get hashCode => Object.hash(runtimeType,festivalId,predictedFor,overall,const DeepCollectionEquality().hash(timeSlots),recommendedPeriod,busiestPeriod,confidence,basedAt,const DeepCollectionEquality().hash(factors),dataUpdatedAt,freshness);

@override
String toString() {
  return 'FestivalAnalysis(festivalId: $festivalId, predictedFor: $predictedFor, overall: $overall, timeSlots: $timeSlots, recommendedPeriod: $recommendedPeriod, busiestPeriod: $busiestPeriod, confidence: $confidence, basedAt: $basedAt, factors: $factors, dataUpdatedAt: $dataUpdatedAt, freshness: $freshness)';
}


}

/// @nodoc
abstract mixin class $FestivalAnalysisCopyWith<$Res>  {
  factory $FestivalAnalysisCopyWith(FestivalAnalysis value, $Res Function(FestivalAnalysis) _then) = _$FestivalAnalysisCopyWithImpl;
@useResult
$Res call({
 int festivalId, DateTime predictedFor, CrowdPrediction overall, List<TimeSlotPrediction> timeSlots, DayPeriod recommendedPeriod, DayPeriod busiestPeriod, double confidence, DateTime basedAt, List<String> factors, DateTime dataUpdatedAt, DataFreshness freshness
});


$CrowdPredictionCopyWith<$Res> get overall;

}
/// @nodoc
class _$FestivalAnalysisCopyWithImpl<$Res>
    implements $FestivalAnalysisCopyWith<$Res> {
  _$FestivalAnalysisCopyWithImpl(this._self, this._then);

  final FestivalAnalysis _self;
  final $Res Function(FestivalAnalysis) _then;

/// Create a copy of FestivalAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? festivalId = null,Object? predictedFor = null,Object? overall = null,Object? timeSlots = null,Object? recommendedPeriod = null,Object? busiestPeriod = null,Object? confidence = null,Object? basedAt = null,Object? factors = null,Object? dataUpdatedAt = null,Object? freshness = null,}) {
  return _then(_self.copyWith(
festivalId: null == festivalId ? _self.festivalId : festivalId // ignore: cast_nullable_to_non_nullable
as int,predictedFor: null == predictedFor ? _self.predictedFor : predictedFor // ignore: cast_nullable_to_non_nullable
as DateTime,overall: null == overall ? _self.overall : overall // ignore: cast_nullable_to_non_nullable
as CrowdPrediction,timeSlots: null == timeSlots ? _self.timeSlots : timeSlots // ignore: cast_nullable_to_non_nullable
as List<TimeSlotPrediction>,recommendedPeriod: null == recommendedPeriod ? _self.recommendedPeriod : recommendedPeriod // ignore: cast_nullable_to_non_nullable
as DayPeriod,busiestPeriod: null == busiestPeriod ? _self.busiestPeriod : busiestPeriod // ignore: cast_nullable_to_non_nullable
as DayPeriod,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,basedAt: null == basedAt ? _self.basedAt : basedAt // ignore: cast_nullable_to_non_nullable
as DateTime,factors: null == factors ? _self.factors : factors // ignore: cast_nullable_to_non_nullable
as List<String>,dataUpdatedAt: null == dataUpdatedAt ? _self.dataUpdatedAt : dataUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,freshness: null == freshness ? _self.freshness : freshness // ignore: cast_nullable_to_non_nullable
as DataFreshness,
  ));
}
/// Create a copy of FestivalAnalysis
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CrowdPredictionCopyWith<$Res> get overall {
  
  return $CrowdPredictionCopyWith<$Res>(_self.overall, (value) {
    return _then(_self.copyWith(overall: value));
  });
}
}


/// Adds pattern-matching-related methods to [FestivalAnalysis].
extension FestivalAnalysisPatterns on FestivalAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FestivalAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FestivalAnalysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FestivalAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _FestivalAnalysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FestivalAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _FestivalAnalysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int festivalId,  DateTime predictedFor,  CrowdPrediction overall,  List<TimeSlotPrediction> timeSlots,  DayPeriod recommendedPeriod,  DayPeriod busiestPeriod,  double confidence,  DateTime basedAt,  List<String> factors,  DateTime dataUpdatedAt,  DataFreshness freshness)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FestivalAnalysis() when $default != null:
return $default(_that.festivalId,_that.predictedFor,_that.overall,_that.timeSlots,_that.recommendedPeriod,_that.busiestPeriod,_that.confidence,_that.basedAt,_that.factors,_that.dataUpdatedAt,_that.freshness);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int festivalId,  DateTime predictedFor,  CrowdPrediction overall,  List<TimeSlotPrediction> timeSlots,  DayPeriod recommendedPeriod,  DayPeriod busiestPeriod,  double confidence,  DateTime basedAt,  List<String> factors,  DateTime dataUpdatedAt,  DataFreshness freshness)  $default,) {final _that = this;
switch (_that) {
case _FestivalAnalysis():
return $default(_that.festivalId,_that.predictedFor,_that.overall,_that.timeSlots,_that.recommendedPeriod,_that.busiestPeriod,_that.confidence,_that.basedAt,_that.factors,_that.dataUpdatedAt,_that.freshness);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int festivalId,  DateTime predictedFor,  CrowdPrediction overall,  List<TimeSlotPrediction> timeSlots,  DayPeriod recommendedPeriod,  DayPeriod busiestPeriod,  double confidence,  DateTime basedAt,  List<String> factors,  DateTime dataUpdatedAt,  DataFreshness freshness)?  $default,) {final _that = this;
switch (_that) {
case _FestivalAnalysis() when $default != null:
return $default(_that.festivalId,_that.predictedFor,_that.overall,_that.timeSlots,_that.recommendedPeriod,_that.busiestPeriod,_that.confidence,_that.basedAt,_that.factors,_that.dataUpdatedAt,_that.freshness);case _:
  return null;

}
}

}

/// @nodoc


class _FestivalAnalysis implements FestivalAnalysis {
  const _FestivalAnalysis({required this.festivalId, required this.predictedFor, required this.overall, required final  List<TimeSlotPrediction> timeSlots, required this.recommendedPeriod, required this.busiestPeriod, required this.confidence, required this.basedAt, required final  List<String> factors, required this.dataUpdatedAt, required this.freshness}): _timeSlots = timeSlots,_factors = factors;
  

@override final  int festivalId;
@override final  DateTime predictedFor;
@override final  CrowdPrediction overall;
 final  List<TimeSlotPrediction> _timeSlots;
@override List<TimeSlotPrediction> get timeSlots {
  if (_timeSlots is EqualUnmodifiableListView) return _timeSlots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_timeSlots);
}

@override final  DayPeriod recommendedPeriod;
@override final  DayPeriod busiestPeriod;
@override final  double confidence;
@override final  DateTime basedAt;
 final  List<String> _factors;
@override List<String> get factors {
  if (_factors is EqualUnmodifiableListView) return _factors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_factors);
}

@override final  DateTime dataUpdatedAt;
@override final  DataFreshness freshness;

/// Create a copy of FestivalAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FestivalAnalysisCopyWith<_FestivalAnalysis> get copyWith => __$FestivalAnalysisCopyWithImpl<_FestivalAnalysis>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FestivalAnalysis&&(identical(other.festivalId, festivalId) || other.festivalId == festivalId)&&(identical(other.predictedFor, predictedFor) || other.predictedFor == predictedFor)&&(identical(other.overall, overall) || other.overall == overall)&&const DeepCollectionEquality().equals(other._timeSlots, _timeSlots)&&(identical(other.recommendedPeriod, recommendedPeriod) || other.recommendedPeriod == recommendedPeriod)&&(identical(other.busiestPeriod, busiestPeriod) || other.busiestPeriod == busiestPeriod)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.basedAt, basedAt) || other.basedAt == basedAt)&&const DeepCollectionEquality().equals(other._factors, _factors)&&(identical(other.dataUpdatedAt, dataUpdatedAt) || other.dataUpdatedAt == dataUpdatedAt)&&(identical(other.freshness, freshness) || other.freshness == freshness));
}


@override
int get hashCode => Object.hash(runtimeType,festivalId,predictedFor,overall,const DeepCollectionEquality().hash(_timeSlots),recommendedPeriod,busiestPeriod,confidence,basedAt,const DeepCollectionEquality().hash(_factors),dataUpdatedAt,freshness);

@override
String toString() {
  return 'FestivalAnalysis(festivalId: $festivalId, predictedFor: $predictedFor, overall: $overall, timeSlots: $timeSlots, recommendedPeriod: $recommendedPeriod, busiestPeriod: $busiestPeriod, confidence: $confidence, basedAt: $basedAt, factors: $factors, dataUpdatedAt: $dataUpdatedAt, freshness: $freshness)';
}


}

/// @nodoc
abstract mixin class _$FestivalAnalysisCopyWith<$Res> implements $FestivalAnalysisCopyWith<$Res> {
  factory _$FestivalAnalysisCopyWith(_FestivalAnalysis value, $Res Function(_FestivalAnalysis) _then) = __$FestivalAnalysisCopyWithImpl;
@override @useResult
$Res call({
 int festivalId, DateTime predictedFor, CrowdPrediction overall, List<TimeSlotPrediction> timeSlots, DayPeriod recommendedPeriod, DayPeriod busiestPeriod, double confidence, DateTime basedAt, List<String> factors, DateTime dataUpdatedAt, DataFreshness freshness
});


@override $CrowdPredictionCopyWith<$Res> get overall;

}
/// @nodoc
class __$FestivalAnalysisCopyWithImpl<$Res>
    implements _$FestivalAnalysisCopyWith<$Res> {
  __$FestivalAnalysisCopyWithImpl(this._self, this._then);

  final _FestivalAnalysis _self;
  final $Res Function(_FestivalAnalysis) _then;

/// Create a copy of FestivalAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? festivalId = null,Object? predictedFor = null,Object? overall = null,Object? timeSlots = null,Object? recommendedPeriod = null,Object? busiestPeriod = null,Object? confidence = null,Object? basedAt = null,Object? factors = null,Object? dataUpdatedAt = null,Object? freshness = null,}) {
  return _then(_FestivalAnalysis(
festivalId: null == festivalId ? _self.festivalId : festivalId // ignore: cast_nullable_to_non_nullable
as int,predictedFor: null == predictedFor ? _self.predictedFor : predictedFor // ignore: cast_nullable_to_non_nullable
as DateTime,overall: null == overall ? _self.overall : overall // ignore: cast_nullable_to_non_nullable
as CrowdPrediction,timeSlots: null == timeSlots ? _self._timeSlots : timeSlots // ignore: cast_nullable_to_non_nullable
as List<TimeSlotPrediction>,recommendedPeriod: null == recommendedPeriod ? _self.recommendedPeriod : recommendedPeriod // ignore: cast_nullable_to_non_nullable
as DayPeriod,busiestPeriod: null == busiestPeriod ? _self.busiestPeriod : busiestPeriod // ignore: cast_nullable_to_non_nullable
as DayPeriod,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,basedAt: null == basedAt ? _self.basedAt : basedAt // ignore: cast_nullable_to_non_nullable
as DateTime,factors: null == factors ? _self._factors : factors // ignore: cast_nullable_to_non_nullable
as List<String>,dataUpdatedAt: null == dataUpdatedAt ? _self.dataUpdatedAt : dataUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,freshness: null == freshness ? _self.freshness : freshness // ignore: cast_nullable_to_non_nullable
as DataFreshness,
  ));
}

/// Create a copy of FestivalAnalysis
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CrowdPredictionCopyWith<$Res> get overall {
  
  return $CrowdPredictionCopyWith<$Res>(_self.overall, (value) {
    return _then(_self.copyWith(overall: value));
  });
}
}

// dart format on
