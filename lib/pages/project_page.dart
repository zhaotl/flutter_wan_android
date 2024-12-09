import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wan_android/network/api.dart';
import 'package:flutter_wan_android/network/bean/app_response/app_response.dart';
import 'package:flutter_wan_android/network/bean/project_list_data/project_list_data.dart';
import 'package:flutter_wan_android/network/bean/project_list_data/project_list_item.dart';
import 'package:flutter_wan_android/network/bean/project_tab/project_tab.dart';
import 'package:flutter_wan_android/network/request_util.dart';
import 'package:flutter_wan_android/pages/base_page.dart';
import 'package:flutter_wan_android/utils/log_util.dart';

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

  @override
  void initState() {
    super.initState();
    HttpGo.instance
        .get<AppResponse<List<ProjectTab>>>(Api.projectCategory)
        .then((res) {
      Wanlog.d('~~~~ start get projects ${res.toString()}');
      if (res.isSuccessful) {
        _tabs = res.data ?? [];
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_tabs.isEmpty) {
      return const Center(
          widthFactor: 1, heightFactor: 1, child: CircularProgressIndicator());
    }

    return DefaultTabController(
      initialIndex: 2,
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
              isScrollable: true,
              tabs: _tabs.map((e) {
                return Tab(text: e.name);
              }).toList()),
        ),
        body: TabBarView(
            children: _tabs.map((e) => ProjectListPage(cid: e.id!)).toList()),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProjectListPage extends StatefulWidget {
  final int cid;

  const ProjectListPage({super.key, required this.cid});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage>
    with BasePage<ProjectListPage> {
  int _currentPageIndex = 1;
  List<ProjectListItem> _projects = [];

  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);

  @override
  void initState() {
    super.initState();
    _getProjectList();
  }

  @override
  Widget build(Object context) {
    return EasyRefresh.builder(
        controller: _refreshController,
        onRefresh: () {
          _currentPageIndex = 1;
          _getProjectList();
        },
        onLoad: () {
          _currentPageIndex++;
          _getProjectList();
        },
        childBuilder: (context, physics) {
          return GridView.builder(
            clipBehavior: Clip.antiAlias,
            itemBuilder: (context, index) {
              return _generateItem(context, index);
            },
            physics: physics,
            itemCount: _projects.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.45),
          );
        });
  }

  _generateItem(BuildContext context, int index) {
    var entity = _projects[index];
    return SizedBox(
      width: double.infinity,
      child: Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 4,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            // todo: goto detail
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                    child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: SizedBox.expand(
                      child: Image.network(entity.envelopePic!,
                          fit: BoxFit.cover)),
                )),
                Container(
                    padding: const EdgeInsets.only(top: 8),
                    height: 46,
                    child: Html(data: entity.title, shrinkWrap: false, style: {
                      "html": Style(
                          margin: Margins.zero,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: FontSize(14),
                          padding: HtmlPaddings.zero,
                          alignment: Alignment.topLeft),
                      "body": Style(
                          margin: Margins.zero,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: FontSize(14),
                          padding: HtmlPaddings.zero,
                          alignment: Alignment.topLeft)
                    }))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getProjectList() async {
    AppResponse<ProjectListData> res = await HttpGo.instance.get(
        "${Api.projectList}$_currentPageIndex/json",
        parameters: {"cid": widget.cid});
    if (_currentPageIndex == 1) {
      _projects.clear();
      _refreshController.finishRefresh();
    } else {
      _refreshController.finishLoad();
    }
    if (res.isSuccessful) {
      setState(() {
        _projects.addAll(res.data?.datas ?? []);
      });
    }
  }
}
