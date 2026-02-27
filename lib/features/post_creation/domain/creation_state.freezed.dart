// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'creation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreationState {
  bool get isProcessing => throw _privateConstructorUsedError;
  XFile? get capturedFile => throw _privateConstructorUsedError;
  String get contentType => throw _privateConstructorUsedError;
  String get caption => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of CreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreationStateCopyWith<CreationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreationStateCopyWith<$Res> {
  factory $CreationStateCopyWith(
    CreationState value,
    $Res Function(CreationState) then,
  ) = _$CreationStateCopyWithImpl<$Res, CreationState>;
  @useResult
  $Res call({
    bool isProcessing,
    XFile? capturedFile,
    String contentType,
    String caption,
    String? errorMessage,
  });
}

/// @nodoc
class _$CreationStateCopyWithImpl<$Res, $Val extends CreationState>
    implements $CreationStateCopyWith<$Res> {
  _$CreationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isProcessing = null,
    Object? capturedFile = freezed,
    Object? contentType = null,
    Object? caption = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isProcessing: null == isProcessing
                ? _value.isProcessing
                : isProcessing // ignore: cast_nullable_to_non_nullable
                      as bool,
            capturedFile: freezed == capturedFile
                ? _value.capturedFile
                : capturedFile // ignore: cast_nullable_to_non_nullable
                      as XFile?,
            contentType: null == contentType
                ? _value.contentType
                : contentType // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: null == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreationStateImplCopyWith<$Res>
    implements $CreationStateCopyWith<$Res> {
  factory _$$CreationStateImplCopyWith(
    _$CreationStateImpl value,
    $Res Function(_$CreationStateImpl) then,
  ) = __$$CreationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isProcessing,
    XFile? capturedFile,
    String contentType,
    String caption,
    String? errorMessage,
  });
}

/// @nodoc
class __$$CreationStateImplCopyWithImpl<$Res>
    extends _$CreationStateCopyWithImpl<$Res, _$CreationStateImpl>
    implements _$$CreationStateImplCopyWith<$Res> {
  __$$CreationStateImplCopyWithImpl(
    _$CreationStateImpl _value,
    $Res Function(_$CreationStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isProcessing = null,
    Object? capturedFile = freezed,
    Object? contentType = null,
    Object? caption = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$CreationStateImpl(
        isProcessing: null == isProcessing
            ? _value.isProcessing
            : isProcessing // ignore: cast_nullable_to_non_nullable
                  as bool,
        capturedFile: freezed == capturedFile
            ? _value.capturedFile
            : capturedFile // ignore: cast_nullable_to_non_nullable
                  as XFile?,
        contentType: null == contentType
            ? _value.contentType
            : contentType // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: null == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CreationStateImpl implements _CreationState {
  const _$CreationStateImpl({
    this.isProcessing = false,
    this.capturedFile,
    this.contentType = 'image',
    this.caption = '',
    this.errorMessage,
  });

  @override
  @JsonKey()
  final bool isProcessing;
  @override
  final XFile? capturedFile;
  @override
  @JsonKey()
  final String contentType;
  @override
  @JsonKey()
  final String caption;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'CreationState(isProcessing: $isProcessing, capturedFile: $capturedFile, contentType: $contentType, caption: $caption, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreationStateImpl &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.capturedFile, capturedFile) ||
                other.capturedFile == capturedFile) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isProcessing,
    capturedFile,
    contentType,
    caption,
    errorMessage,
  );

  /// Create a copy of CreationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreationStateImplCopyWith<_$CreationStateImpl> get copyWith =>
      __$$CreationStateImplCopyWithImpl<_$CreationStateImpl>(this, _$identity);
}

abstract class _CreationState implements CreationState {
  const factory _CreationState({
    final bool isProcessing,
    final XFile? capturedFile,
    final String contentType,
    final String caption,
    final String? errorMessage,
  }) = _$CreationStateImpl;

  @override
  bool get isProcessing;
  @override
  XFile? get capturedFile;
  @override
  String get contentType;
  @override
  String get caption;
  @override
  String? get errorMessage;

  /// Create a copy of CreationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreationStateImplCopyWith<_$CreationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
