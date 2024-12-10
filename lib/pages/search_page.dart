import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_wan_android/network/api.dart';
import 'package:flutter_wan_android/network/bean/app_response/app_response.dart';
import 'package:flutter_wan_android/network/bean/hot_key/hot_key.dart';
import 'package:flutter_wan_android/network/request_util.dart';
import 'package:flutter_wan_android/utils/log_util.dart';
import 'package:get/get.dart';
import 'package:mmkv/mmkv.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String historyKey = "historyKey";
  List<String> _histories = [];

  List<HotKey> hotKeys = [];

  List<Color> keywordsColors = [
    const Color(0xffe35454),
    const Color(0xff549A3A),
    const Color(0xff34856E),
    const Color(0xffB59B42),
    const Color(0xff9B4BAA),
    const Color(0xff4966B1),
  ];

  @override
  void initState() {
    super.initState();
    try {
      var mmkv = MMKV.defaultMMKV();
      String historyContent = mmkv.decodeString(historyKey) ?? "";
      if (historyContent.trim().isEmpty) {
        _histories.addAll(
            (json.decoder.convert(historyContent) as List<dynamic>)
                .map((e) => e as String));
      }
      _getHotKeys();
    } catch (e) {
      Wanlog.e("load history words -- ${e.toString()}");
    }
  }

  _getHotKeys() async {
    AppResponse<List<HotKey>> res = await HttpGo.instance.get(Api.hotKeywords);
    if (res.isSuccessful) {
      setState(() {
        hotKeys.clear();
        hotKeys.addAll(res.data!);
      });
    }
  }

  _saveHistoryToLocal() {
    try {
      var mmkv = MMKV.defaultMMKV();
      String historyContent = json.encoder.convert(_histories);
      mmkv.encodeString(historyKey, historyContent);
    } catch (e) {
      Wanlog.e("save history words error -- ${e.toString()}");
    }
  }

  _onSearch(String content) {
    setState(() {
      if (_histories.contains(content)) {
        _histories.remove(content);
      }
      _histories.insert(0, content);
    });
    // goto search result page
    // Get.to(() => SearchResultPage())
  }

  _deleteHisotry(int index) {
    setState(() {
      _histories.removeAt(index);
    });
  }

  _onClearClick() async {
    bool result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("提示"),
            content: const Text("确定要清除所有搜索记录么？"),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back(result: false);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Get.back(result: true);
                  },
                  child: const Text("Confirm"))
            ],
          );
        });
    if (result == true) {
      setState(() {
        _histories.clear();
        _saveHistoryToLocal();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    Wanlog.d("dispose ~~~~~~");
    _saveHistoryToLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          iconTheme: const IconThemeData(color: Colors.white),
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: MySearchBar(
              onSubmit: (value) {
                _onSearch(value);
              },
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                child: Wrap(
                    direction: Axis.horizontal,
                    runSpacing: 8,
                    alignment: WrapAlignment.start,
                    spacing: 16,
                    runAlignment: WrapAlignment.center,
                    children: List.generate(hotKeys.length, (index) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: keywordsColors[
                                  index % keywordsColors.length]),
                          child: Text(
                            hotKeys[index].name!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    })),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("搜索记录", style: TextStyle(fontSize: 16)),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        _onClearClick();
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Text("清空"),
                      ),
                    ),
                  ))
                ],
              ),
              Container(
                height: 1,
                margin: const EdgeInsets.only(top: 12),
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.grey),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: _histories.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Text(_histories[index]),
                                Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                            onPressed: () {
                                              _deleteHisotry(index);
                                            },
                                            icon: const Icon(Icons.close))))
                              ],
                            ),
                          ),
                        );
                      }))
            ],
          ),
        ));
  }
}

class MySearchBar extends StatefulWidget {
  final Function(String) onSubmit;

  const MySearchBar({super.key, required this.onSubmit});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: TextField(
        autofocus: true,
        decoration: const InputDecoration(
            hintText: "搜索",
            contentPadding: EdgeInsets.only(bottom: 10),
            border: InputBorder.none,
            icon: Icon(Icons.search)),
        onSubmitted: (value) => widget.onSubmit(value),
      ),
    );
  }
}
