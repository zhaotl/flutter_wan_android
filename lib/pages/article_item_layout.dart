import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wan_android/network/bean/articel_data/article_item.dart';
import 'package:flutter_wan_android/pages/detail_page.dart';
import 'package:get/get.dart';

class ArticleItemLayout extends StatefulWidget {
  final ArticleItem item;
  final bool? showCollectionBtn;
  final void Function() onCollectTap;

  const ArticleItemLayout(
      {super.key,
      required this.item,
      this.showCollectionBtn,
      required this.onCollectTap});

  @override
  State<ArticleItemLayout> createState() => _ArticleItemLayoutState();
}

class _ArticleItemLayoutState extends State<ArticleItemLayout> {
  @override
  void initState() {
    super.initState();
    widget.item.addListener(_onCollectChange);
  }

  @override
  void dispose() {
    super.dispose();
    widget.item.removeListener(_onCollectChange);
  }

  @override
  void didUpdateWidget(covariant ArticleItemLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      oldWidget.item.removeListener(_onCollectChange);
      widget.item.addListener(_onCollectChange);
    }
  }

  void _onCollectChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    String publishTime = DateTime.fromMillisecondsSinceEpoch(
            widget.item.publishTime ?? DateTime.now().microsecond)
        .toString();
    publishTime = publishTime.substring(0, publishTime.length - 4);
    StringBuffer sb = StringBuffer(widget.item.superChapterName ?? "");
    if (sb.isNotEmpty &&
        widget.item.chapterName != null &&
        widget.item.chapterName?.isNotEmpty == true) {
      sb.write('.');
    }
    sb.write(widget.item.chapterName ?? "");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 8,
        color: Colors.white,
        child: InkWell(
          onTap: () {
            // goto Detail
            Get.to(() => DetailPage(
                url: widget.item.link!, title: widget.item.title ?? ''));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    if (widget.item.type == 1)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text('置顶', style: TextStyle(color: Colors.red)),
                      ),
                    Container(
                      padding: widget.item.type == 1
                          ? const EdgeInsets.only(left: 8)
                          : const EdgeInsets.only(left: 12),
                      child: Text(widget.item.author?.isNotEmpty == true
                          ? widget.item.author!
                          : widget.item.shareUser ?? ""),
                    ),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.only(right: 8),
                            alignment: Alignment.centerRight,
                            child: Text(publishTime)))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                  child: Row(
                    children: [
                      Expanded(
                          child: Html(
                        data: widget.item.title,
                        style: {
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
                        },
                      ))
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(sb.toString()),
                    ),
                    Expanded(
                        child: Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.only(right: 8),
                      alignment: Alignment.centerRight,
                      child: Builder(builder: (context) {
                        return InkWell(
                          onTap: widget.onCollectTap,
                          child: Image.asset(widget.item.isCollect
                              ? 'assets/images/icon_collect.png'
                              : 'assets/images/icon_uncollect.png'),
                        );
                      }),
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
