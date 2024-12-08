import 'package:flutter/material.dart';
import 'package:flutter_wan_android/network/api.dart';
import 'package:flutter_wan_android/network/bean/app_response/app_response.dart';
import 'package:flutter_wan_android/network/bean/project_tab/project_tab.dart';
import 'package:flutter_wan_android/network/request_util.dart';
import 'package:flutter_wan_android/pages/base_page.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with
        BasePage<ProjectPage>,
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin {
  List<ProjectTab> _tabs = List.empty();
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    HttpGo.instance
        .get<AppResponse<List<ProjectTab>>>(Api.projectCategory)
        .then((res) {
      if (res.isSuccessful) {
        _tabs = res.data ?? [];
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  bool get wantKeepAlive => true;
}
