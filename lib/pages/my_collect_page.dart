import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/network/api.dart';
import 'package:flutter_wan_android/network/bean/app_response/app_response.dart';
import 'package:flutter_wan_android/network/bean/articel_data/articel_data.dart';
import 'package:flutter_wan_android/network/bean/articel_data/article_item.dart';
import 'package:flutter_wan_android/network/bean/my_collect_web/my_collect_web.dart';
import 'package:flutter_wan_android/network/request_util.dart';
import 'package:flutter_wan_android/pages/article_item_layout.dart';
import 'package:flutter_wan_android/pages/base_page.dart';
import 'package:flutter_wan_android/pages/detail_page.dart';
import 'package:get/get.dart';

class MyCollectPage extends StatefulWidget {
  const MyCollectPage({super.key});

  @override
  State<MyCollectPage> createState() => _MyCollectPageState();
}

class _MyCollectPageState extends State<MyCollectPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("我的收藏", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigoAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          TabBar(
              controller: _tabController,
              isScrollable: false,
              tabs: const [Tab(text: "文章"), Tab(text: "网站")]),
          Expanded(
              child: TabBarView(controller: _tabController, children: const [
            _CollectListPage(tag: 0),
            _CollectListPage(tag: 1)
          ]))
        ],
      ),
    );
  }
}

class _CollectListPage extends StatefulWidget {
  final int tag;

  const _CollectListPage({required this.tag});

  @override
  State<_CollectListPage> createState() => _CollectListPageState();
}

class _CollectListPageState extends State<_CollectListPage>
    with AutomaticKeepAliveClientMixin {
  int _pageIndex = 0;
  final List<ArticleItem> _articles = [];
  final List<MyCollectWeb> _webs = [];

  late var articleObs = _articles.obs;
  late var webObs = _webs.obs;

  bool _over = false;

  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishRefresh: true, controlFinishLoad: true);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.tag == 1) {
      _over = true;
    }
    return FutureBuilder(future: (() async {
      _pageIndex = 0;
      return await _requestData();
    })(), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.data == false) {
          return RetryWidget(onTapRetry: () => setState(() {}));
        }
        return widget.tag == 0 ? _buildContent() : _buildWebList();
      } else {
        return const Center(
            widthFactor: 1,
            heightFactor: 1,
            child: CircularProgressIndicator());
      }
    });
  }

  Widget _buildContent() {
    if (_articles.isEmpty) {
      return const EmptyWidget();
    }
    return EasyRefresh.builder(
        controller: _refreshController,
        onLoad: _onLoadData,
        onRefresh: _onRefresh,
        childBuilder: (context, physics) {
          return Obx(() {
            return ListView.builder(
                physics: physics,
                itemCount: articleObs.length,
                itemBuilder: (context, index) {
                  var item = articleObs[index];
                  return ArticleItemLayout(item: item, onCollectTap: () {});
                });
          });
        });
  }

  Widget _buildWebList() {
    if (_webs.isEmpty) {
      return const EmptyWidget();
    }

    return Obx(() {
      return ListView.builder(
          itemCount: webObs.length,
          itemBuilder: (context, index) {
            var item = webObs[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
              child: Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 8,
                child: InkWell(
                  onTap: () {
                    Get.to(() => DetailPage(
                        url: item.link ?? "", title: item.name ?? ""));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text.rich(TextSpan(
                            text: item.link,
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()))
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }

  Future<bool> _requestData() async {
    if (widget.tag == 0) {
      AppResponse<ArticelData> res =
          await HttpGo.instance.get("${Api.collectList}/$_pageIndex/json");
      if (res.isSuccessful) {
        if (_pageIndex == 0) {
          _articles.clear();
        }
        _over = res.data?.over ?? false;
        _articles.addAll(res.data?.datas ?? []);
      }
      return true;
    } else {
      AppResponse<List<MyCollectWeb>> res =
          await HttpGo.instance.get(Api.collectWebaddressList);
      if (res.isSuccessful) {
        if (_pageIndex == 0) {
          _webs.clear();
        }
        _webs.addAll(res.data ?? []);
      }
      return true;
    }
  }

  void _onRefresh() async {
    _pageIndex = 0;
    await _requestData();
    _refreshController.finishRefresh();
    if (widget.tag == 0) {
      articleObs.refresh();
    }
  }

  void _onLoadData() async {
    _pageIndex++;
    await _requestData();
    _refreshController
        .finishLoad(_over ? IndicatorResult.noMore : IndicatorResult.success);
    if (widget.tag == 0) {
      articleObs.refresh();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
