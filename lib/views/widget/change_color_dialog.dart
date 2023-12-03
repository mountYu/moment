import 'package:flutter/material.dart';
import 'package:moment/views/widget/name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class changeColorDialogWidget extends StatelessWidget {
  changeColorDialogWidget({super.key});
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // ダイアログの背景色を透明に設定
      child: Container(
        width: double.infinity,
        height: 350, // モーダルの高さを設定
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8), // モーダルの内部の色
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: NameWidget(name: user.displayName!, fontsize: 50.0),
            ),
            SizedBox(
              height: 200,
            ),
            Text(
              'Select theme color',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}

class ThemePreferences {
  Future<void> saveThemeColor(String color) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_color', color);
  }

  Future<String> getThemeColor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme_color') ?? 'red'; // デフォルトカラー
  }
}
