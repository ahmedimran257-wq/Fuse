import 'package:freezed_annotation/freezed_annotation.dart';
import 'post_model.dart';

part 'feed_state.freezed.dart';

@freezed
class FeedState with _$FeedState {
  const factory FeedState({
    @Default([]) List<Post> posts,
    @Default(true) bool isLoading,
    String? errorMessage,
  }) = _FeedState;
}
