import 'package:json_annotation/json_annotation.dart';

import 'project_list_item.dart';

part 'project_list_data.g.dart';

@JsonSerializable()
class ProjectListData {
  int? curPage;
  List<ProjectListItem>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;

  ProjectListData({
    this.curPage,
    this.datas,
    this.offset,
    this.over,
    this.pageCount,
    this.size,
    this.total,
  });

  factory ProjectListData.fromJson(Map<String, dynamic> json) {
    return _$ProjectListDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProjectListDataToJson(this);
}
