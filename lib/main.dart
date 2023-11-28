import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moment/signin_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'contact_callbacks_sample.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // runApp 前に何かを実行したいときはこれが必要です。
  await Firebase.initializeApp(
    // これが Firebase の初期化処理です。
    options: DefaultFirebaseOptions.ios,
  );
  if (FirebaseAuth.instance.currentUser == null) {
    runApp(
      // This widget is the root of your application.
      ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: 'LINESeed',
          ),
          home: const SignInPage(),
        ),
      ),
    );
  } else {
    runApp(
      // This widget is the root of your application.
      ProviderScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: 'LINESeed',
          ),
          home: const MomentWidget(),
        ),
      ),
    );
  }
}


//TODO
//画像を写真で撮って、自分のドキュメントにPostクラスが保存される。
//データベースに入ったイメージが全て読み込まれて、POPSとして表示される。
//POPSをタップすると写真が拡大表示される。
//profileコレクションで友達を管理する
  //friendRequest
  //friend
//友達の今日のPOSTが自分の画面にも表示される。リアルタイムに。