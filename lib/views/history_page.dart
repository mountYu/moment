import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // 背景を黒色に設定
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is the History page',
              style: TextStyle(
                color: Colors.white, // テキストの色を白に設定
              ),
            ),
            // ここに他のウィジェットを追加
          ],
        ),
      ),
    );
  }
}
