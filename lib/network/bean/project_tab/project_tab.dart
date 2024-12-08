import 'package:json_annotation/json_annotation.dart';

part 'project_tab.g.dart';

@JsonSerializable()
class ProjectTab {
  List<dynamic>? articleList;
  String? author;
  List<dynamic>? children;
  int? courseId;
  String? cover;
  String? desc;
  int? id;
  String? lisense;
  String? lisenseLink;
  String? name;
  int? order;
  int? parentChapterId;
  int? type;
  bool? userControlSetTop;
  int? visible;

  ProjectTab({
    this.articleList,
    this.author,
    this.children,
    this.courseId,
    this.cover,
    this.desc,
    this.id,
    this.lisense,
    this.lisenseLink,
    this.name,
    this.order,
    this.parentChapterId,
    this.type,
    this.userControlSetTop,
    this.visible,
  });

  factory ProjectTab.fromJson(Map<String, dynamic> json) {
    return _$ProjectTabFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProjectTabToJson(this);
}
