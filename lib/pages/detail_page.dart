import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_wan_android/utils/log_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  final String url;
  final String title;

  const DetailPage({super.key, required this.url, required this.title});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Key progressKey = GlobalKey();
  Key contentKey = GlobalKey();

  final WebViewController _webViewController = WebViewController();

  bool finish = false;

  @override
  void initState() {
    super.initState();
    Wanlog.d("~~~~~ detail url is ${widget.url}");
    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
        Wanlog.d("webview start ~~~~: $url");
      }, onProgress: (progress) {
        Wanlog.d("webview load progress ~~~~: $progress");
      }, onPageFinished: (content) {
        Wanlog.d("webview finished ~~~~~~~ ");
        setState(() {
          finish = true;
        });
      }));
    _webViewController.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Html(
          data: widget.title,
          style: {
            "html": Style(
                color: Colors.white,
                margin: Margins.zero,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontSize: FontSize(18),
                padding: HtmlPaddings.zero,
                alignment: Alignment.topLeft),
            "body": Style(
                color: Colors.white,
                margin: Margins.zero,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontSize: FontSize(18),
                padding: HtmlPaddings.zero,
                alignment: Alignment.topLeft)
          },
        ),
        backgroundColor: Colors.redAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: !finish
          ? Center(key: progressKey, child: const CircularProgressIndicator())
          : WebViewWidget(controller: _webViewController, key: contentKey),
    );
  }
}
