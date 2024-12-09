import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'project_item_tag.g.dart';

@JsonSerializable()
class ProjectListItemTags {
  String? name;
  String? url;

  ProjectListItemTags({this.name, this.url});

  factory ProjectListItemTags.fromJson(Map<String, dynamic> json) =>
      _$ProjectListItemTagsFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectListItemTagsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
