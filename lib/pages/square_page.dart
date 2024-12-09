import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/network/api.dart';
import 'package:flutter_wan_android/network/bean/app_response/app_response.dart';
import 'package:flutter_wan_android/network/bean/articel_data/articel_data.dart';
import 'package:flutter_wan_android/network/bean/articel_data/article_item.dart';
import 'package:flutter_wan_android/network/request_util.dart';
import 'package:flutter_wan_android/pages/article_item_layout.dart';
import 'package:flutter_wan_android/pages/base_page.dart';
import 'package:flutter_wan_android/user.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SquarePage extends StatefulWidget {
  const SquarePage({super.key});

  @override
  State<SquarePage> createState() => _SquarePageState();
}

class _SquarePageState extends State<SquarePage>
    with BasePage<SquarePage>, AutomaticKeepAliveClientMixin {
  int _currentPageIndex = 0;

  List<ArticleItem> _articles = [];
  late RxList<ArticleItem> _articleObs = _articles.obs;

  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);

  @override
  Widget build(BuildContext context) {
    // 监听user， 当登录状态时， 重新build
    return Consumer<User>(builder: (context, user, child) {
      return FutureBuilder(
          future: _requestData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == false) {
                return RetryWidget(onTapRetry: () {
                  setState(() {});
                });
              }
              return _buildContent();
            } else {
              return const Center(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: CircularProgressIndicator());
            }
          });
    });
  }

  Widget _buildContent() {
    if (_articles.isEmpty) {
      return const EmptyWidget();
    }

    return EasyRefresh.builder(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoad: _laodRequest,
        childBuilder: (context, physics) {
          return Obx(() {
            var items = _articleObs;
            return ListView.builder(
              physics: physics,
              itemBuilder: (context, index) {
                ArticleItem item = items[index];
                return ArticleItemLayout(
                    item: item,
                    onCollectTap: () {
                      // Todo: goto detail page
                    });
              },
              itemCount: items.length,
            );
          });
        });
  }

  _onRefresh() {
    _currentPageIndex = 0;
    _requestData();
    _refreshController.finishRefresh();
    _articleObs.refresh();
  }

  _laodRequest() {
    _currentPageIndex++;
    _requestData();
    _refreshController.finishLoad();
    _articleObs.refresh();
  }

  Future<bool> _requestData() async {
    AppResponse<ArticelData> res = await HttpGo.instance
        .get("${Api.plazaArticleList}$_currentPageIndex/json");
    if (_currentPageIndex == 0) {
      _articles.clear();
    }
    if (res.isSuccessful) {
      _articles.addAll(res.data?.datas ?? []);
      return true;
    }

    return false;
  }

  @override
  bool get wantKeepAlive => true;
}
