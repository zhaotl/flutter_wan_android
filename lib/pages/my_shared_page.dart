import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/network/api.dart';
import 'package:flutter_wan_android/network/bean/app_response/app_response.dart';
import 'package:flutter_wan_android/network/bean/articel_data/article_item.dart';
import 'package:flutter_wan_android/network/bean/my_shared_data/my_shared_data.dart';
import 'package:flutter_wan_android/network/request_util.dart';
import 'package:flutter_wan_android/pages/article_item_layout.dart';
import 'package:flutter_wan_android/pages/base_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MySharedPage extends StatefulWidget {
  const MySharedPage({super.key});

  @override
  State<MySharedPage> createState() => _MySharedPageState();
}

class _MySharedPageState extends State<MySharedPage> {
  int _pageIndex = 1;
  final List<ArticleItem> _myShares = [];
  bool _over = true;
  late var myShares = _myShares.obs;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  final EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    _requestData();
  }

  @override
  Widget build(Object context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyanAccent,
          title: const Text("我的分享", style: TextStyle(color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black87),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: () {
                  _showShareDialog();
                },
                icon: const Icon(Icons.add),
              ),
            )
          ],
        ),
        body: _build());
  }

  Widget _build() {
    if (_myShares.isEmpty) {
      return const EmptyWidget();
    } else {
      return EasyRefresh.builder(
          onLoad: _onLoad,
          onRefresh: _onRefresh,
          controller: _refreshController,
          childBuilder: (context, physics) {
            return Obx(() {
              return ListView.builder(
                  physics: physics,
                  itemCount: myShares.length,
                  itemBuilder: (context, index) {
                    var item = myShares[index];
                    return ArticleItemLayout(
                        item: item,
                        onCollectTap: () {
                          _onCollectClick(item);
                        });
                  });
            });
          });
    }
  }

  _onCollectClick(ArticleItem itemEntity) async {
    bool collected = itemEntity.isCollect;
    AppResponse<dynamic> res = await (collected
        ? HttpGo.instance.post("${Api.uncollectArticel}${itemEntity.id}/json")
        : HttpGo.instance.post("${Api.collectArticle}${itemEntity.id}/json"));

    if (res.isSuccessful) {
      Fluttertoast.showToast(msg: collected ? "取消收藏！" : "收藏成功！");
      itemEntity.collect = !itemEntity.isCollect;
    } else {
      Fluttertoast.showToast(
          msg: (collected ? "取消失败 -- " : "收藏失败 -- ") +
              (res.errorMsg ?? res.errorCode.toString()));
    }
  }

  Future<bool> _requestData() async {
    AppResponse<MySharedData> res =
        await HttpGo.instance.get("${Api.sharedList}$_pageIndex/json");
    if (res.isSuccessful) {
      _over = res.data?.shareArticles?.over ?? false;
      if (_pageIndex == 1) {
        _myShares.clear();
      }
      _myShares.addAll(res.data?.shareArticles?.datas ?? []);
      return true;
    }
    return false;
  }

  _onLoad() async {
    _pageIndex++;
    await _requestData();
    _refreshController
        .finishLoad(_over ? IndicatorResult.noMore : IndicatorResult.success);
    myShares.refresh();
  }

  _onRefresh() async {
    _pageIndex = 1;
    await _requestData();
    _refreshController.finishRefresh();
    myShares.refresh();
  }

  _showShareDialog() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        hintText: "文章标题",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: TextField(
                    controller: _linkController,
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        hintText: "文章链接",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextButton(
                      onPressed: () async {
                        bool result = await _onShareClick();
                        if (result) {
                          Get.back();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: const Text("分享",
                            style: TextStyle(color: Colors.white)),
                      )),
                )
              ],
            ),
          );
        });
  }

  Future<bool> _onShareClick() async {
    FocusScope.of(context).unfocus();
    AppResponse<dynamic> res = await HttpGo.instance.post(Api.shareArticle,
        data: {"title": _titleController.text, "link": _linkController.text});
    if (res.isSuccessful) {
      Fluttertoast.showToast(msg: "分享成功");
      return true;
    } else {
      Fluttertoast.showToast(msg: "分享失败");
      return false;
    }
  }
}
