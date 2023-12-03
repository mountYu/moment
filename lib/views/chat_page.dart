import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:moment/views/widget/name.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String chatUserName = 'Yuta Nihei';
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.black, // 背景を黒色に設定
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(children: [
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 30),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  NameWidget(name: chatUserName, fontsize: 50.0),
                ]),
              ),
              Positioned(
                  bottom: 12, // テキストの下部に線を配置
                  child: Row(
                    children: [
                      Container(
                        height: 2,
                        width: 30,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      Container(
                        height: 2,
                        width: deviceWidth - 30,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5), // 左上角を丸める
                            bottomLeft: Radius.circular(5), // 左下角を丸める
                          ),
                        ),
                      ),
                    ],
                  )),
            ]),

            // ここに他のウィジェットを追加
          ],
        ),
      ),
    );
  }
}
