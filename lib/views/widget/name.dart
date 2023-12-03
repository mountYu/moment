import 'package:flutter/material.dart';

class NameWidget extends StatelessWidget {
  final String name; // 引数として name を受け取る
  final double fontsize; // 引数として fontsize を受け取る

  // コンストラクタで name と fontsize を初期化
  const NameWidget({
    super.key,
    required this.name,
    required this.fontsize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name[0],
          style: TextStyle(
            fontSize: fontsize,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        Text(
          name.length > 1 ? name[1] : '',
          style: TextStyle(
            fontSize: fontsize,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 255, 0, 0),
          ),
        ),
        Text(
          name.length > 2 ? name.substring(2) : '',
          style: TextStyle(
            fontSize: fontsize,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ],
    );
  }
}
