import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/network/api.dart';
import 'package:flutter_wan_android/network/bean/app_response/app_response.dart';
import 'package:flutter_wan_android/network/bean/articel_data/articel_data.dart';
import 'package:flutter_wan_android/network/bean/articel_data/article_item.dart';
import 'package:flutter_wan_android/network/request_util.dart';
import 'package:flutter_wan_android/pages/article_item_layout.dart';
import 'package:flutter_wan_android/pages/detail_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SearchResultPage extends StatefulWidget {
  final String keyword;

  const SearchResultPage({super.key, required this.keyword});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final int _currentPageIndex = 0;
  final List<ArticleItem> _articles = [];
  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);

  @override
  void initState() {
    super.initState();
    _searchRequest();
  }

  void _searchRequest() async {
    AppResponse<ArticelData> res = await HttpGo.instance.post(
        "${Api.searchForKeyword}/$_currentPageIndex/json",
        data: {"k": widget.keyword});
    if (res.isSuccessful) {
      if (_currentPageIndex == 0) {
        _articles.clear();
      }
      setState(() {
        _articles.addAll(res.data?.datas ?? []);
      });
      _refreshController.finishRefresh();
      _refreshController.finishLoad();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.keyword, style: const TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.indigoAccent),
      body: EasyRefresh.builder(
          controller: _refreshController,
          childBuilder: (context, physics) {
            return ListView.builder(
                itemCount: _articles.length,
                physics: physics,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(() => DetailPage(
                          url: _articles[index].link ?? "",
                          title: _articles[index].title ?? ""));
                    },
                    child: ArticleItemLayout(
                        item: _articles[index],
                        onCollectTap: () {
                          _onCollectClick(_articles[index]);
                        }),
                  );
                });
          }),
    );
  }

  _onCollectClick(ArticleItem item) async {
    bool collected = item.isCollect;
    AppResponse<dynamic> res = await (collected
        ? HttpGo.instance.post("${Api.uncollectArticel}${item.id}/json")
        : HttpGo.instance.post("${Api.collectArticle}${item.id}/json"));

    if (res.isSuccessful) {
      Fluttertoast.showToast(msg: collected ? "取消收藏！" : "收藏成功！");
      item.isCollect = !item.isCollect;
    } else {
      Fluttertoast.showToast(
          msg: (collected ? "取消失败 -- " : "收藏失败 -- ") +
              (res.errorMsg ?? res.errorCode.toString()));
    }
  }
}
