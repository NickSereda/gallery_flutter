import 'package:json_annotation/json_annotation.dart';
import 'package:photo_gallery_flutter/models/photo.dart';

part 'result.g.dart';

@JsonSerializable()
class Result {
  @JsonKey(name: "hits")
  List<Photo> images;

  Result({
    required this.images,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
