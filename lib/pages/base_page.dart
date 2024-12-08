import 'package:flutter/material.dart';

mixin BasePage<T extends StatefulWidget> on State<T> {
  bool showingLoading = false;

  showLoadingDialog() async {
    if (showingLoading) return;
    showingLoading = true;
    await showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Text('请稍后...'),
                )
              ],
            ),
          );
        });
    showingLoading = false;
  }

  dismissDialog() {
    if (showingLoading) Navigator.of(context).pop();
  }
}

class RetryWidget extends StatelessWidget {
  final void Function() onTapRetry;

  const RetryWidget({super.key, required this.onTapRetry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: const SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Icon(Icons.refresh),
            ),
            Text('加载失败，点击重试。')
          ],
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 16), child: Icon(Icons.book)),
          Text("无数据")
        ],
      ),
    );
  }
}
