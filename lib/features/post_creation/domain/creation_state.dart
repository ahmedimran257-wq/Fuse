import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:camera/camera.dart';

part 'creation_state.freezed.dart';

@freezed
class CreationState with _$CreationState {
  const factory CreationState({
    @Default(false) bool isProcessing,
    XFile? capturedFile,
    @Default('image') String contentType,
    @Default('') String caption,
    String? errorMessage,
  }) = _CreationState;
}
