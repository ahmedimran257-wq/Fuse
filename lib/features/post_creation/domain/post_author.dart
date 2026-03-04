import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_author.freezed.dart';
part 'post_author.g.dart';

@freezed
class PostAuthor with _$PostAuthor {
  const factory PostAuthor({
    required String id,
    required String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _PostAuthor;

  factory PostAuthor.fromJson(Map<String, dynamic> json) =>
      _$PostAuthorFromJson(json);
}
