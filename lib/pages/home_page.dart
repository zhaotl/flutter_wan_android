import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wan_android/network/api.dart';
import 'package:flutter_wan_android/network/bean/app_response/app_response.dart';
import 'package:flutter_wan_android/network/bean/articel_data/articel_data.dart';
import 'package:flutter_wan_android/network/bean/articel_data/article_item.dart';
import 'package:flutter_wan_android/network/bean/banner/banner.dart';
import 'package:flutter_wan_android/network/request_util.dart';
import 'package:flutter_wan_android/pages/article_item_layout.dart';
import 'package:flutter_wan_android/pages/base_page.dart';
import 'package:flutter_wan_android/utils/log_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with BasePage<HomePage>, AutomaticKeepAliveClientMixin {
  var _pageIndex = 0;
  List<ArticleItem> _articleList = List.empty();
  List<BannerEntity>? _banners;
  var retryCount = 0.obs;
  var dataUpdate = 0.obs;

  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(builder: (context, user, child) {
      return Obx(() {
        Wanlog.i('retry count: ${retryCount.value}');
        return _build(context);
      });
    });
  }

  Widget _build(BuildContext context) {
    return FutureBuilder(
        future: _refreshRequest(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == false) {
              return RetryWidget(onTapRetry: () => retryCount.value++);
            }
            return Obx(() {
              Wanlog.d('data update: ${dataUpdate.value}');
              return Scaffold(
                body: EasyRefresh.builder(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoad: _loadRequest,
                  childBuilder: (context, physics) {
                    return CustomScrollView(
                      physics: physics,
                      slivers: [
                        if (_banners != null && _banners!.isNotEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: CarouselSlider(
                                  items: _bannerList(),
                                  options: CarouselOptions(
                                      enableInfiniteScroll: true,
                                      autoPlay: true,
                                      aspectRatio: 2.0,
                                      enlargeCenterPage: true,
                                      enlargeStrategy:
                                          CenterPageEnlargeStrategy.height)),
                            ),
                          ),
                        SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                          return ArticleItemLayout(
                              item: _articleList[index],
                              onCollectTap: () {
                                _onCollectClick(_articleList[index]);
                              });
                        }, childCount: _articleList.length))
                      ],
                    );
                  },
                ),
              );
            });
          } else {
            return const Center(
                widthFactor: 1,
                heightFactor: 1,
                child: CircularProgressIndicator());
          }
        });
  }

  _onCollectClick(ArticleItem item) async {
    bool collected = item.isCollect;
    AppResponse<dynamic> res = await HttpGo.instance.post(collected
        ? '${Api.uncollectArticel}${item.id}/json'
        : '${Api.collectArticle}${item.id}/json');
    if (res.isSuccessful) {
      Wanlog.d(' click collected button success. ~~~~~~');
      Fluttertoast.showToast(msg: collected ? "取消成功" : '收藏成功');
      item.collect = !collected;
    } else {
      Fluttertoast.showToast(
          msg: (collected ? "取消失败" : "收藏失败") +
              (res.errorMsg ?? res.errorCode?.toString() ?? ""));
    }
  }

  void _onRefresh() async {
    await _refreshRequest();
    _refreshController.finishRefresh();
    dataUpdate.refresh();
  }

  void _loadRequest() async {
    _pageIndex++;
    Wanlog.d('~~~~~~~~ start loadRequest');
    AppResponse<ArticelData> res =
        await HttpGo.instance.get("${Api.homePageArticle}$_pageIndex/json");
    Wanlog.d('res is ${res.runtimeType}');
    if (res.isSuccessful) {
      Wanlog.d('res is successful ~~~~~~~~~');
      _articleList.addAll(res.data?.datas ?? List.empty());
    }
    _refreshController.finishLoad();
    dataUpdate.refresh();
  }

  List<Widget> _bannerList() =>
      _banners
          ?.map((e) => Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    child: Image.network(e.imagePath!,
                        fit: BoxFit.cover, width: double.infinity)),
              ))
          .toList() ??
      List.empty();

  Future<bool> _refreshRequest() async {
    _pageIndex = 0;
    bool resultStatus = true;
    List<ArticleItem> result = [];
    AppResponse<List<BannerEntity>> bannerRes =
        await HttpGo.instance.get(Api.banner);
    _banners = bannerRes.data;
    resultStatus &= bannerRes.isSuccessful;

    // Todo: Top article 没有数据，所以解析有问题
    // AppResponse<List<ArticleItem>> topRes =
    //     await HttpGo.instance.get(Api.topArticle);
    // resultStatus &= topRes.isSuccessful;
    // if (topRes.isSuccessful) {
    //   result.addAll(topRes.data ?? List.empty());
    // }

    Wanlog.d('~~~~~~~~ start homePageArticle');
    AppResponse<ArticelData> articleRes =
        await HttpGo.instance.get("${Api.homePageArticle}$_pageIndex/json");
    resultStatus &= articleRes.isSuccessful;
    Wanlog.d('~~~~~~~~ articleRes is ${articleRes.runtimeType}');

    if (articleRes.isSuccessful) {
      result.addAll(articleRes.data?.datas ?? List.empty());
    }

    _articleList = result;
    return resultStatus;
  }

  @override
  bool get wantKeepAlive => true;
}
