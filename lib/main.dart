import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moment/views/signin_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'views/chat_page.dart';
import 'package:flutter/material.dart';
import 'views/pops_page.dart';
import 'views/chat_page.dart';
import 'views/history_page.dart';
import 'views/generate_post.dart';

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
          routes: {
            '/': (context) => MainFrame(),
            '/chat': (context) => ChatPage(),
            '/history': (context) => HistoryPage(),
            // 他のルートもここに追加
          },
        ),
      ),
    );
  }
}

class MainFrame extends StatefulWidget {
  @override
  _MainFrameState createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  int _selectedIndex = 0; // 現在選択されているタブのインデックス

  // 各ページのウィジェット
  final List<Widget> _pages = [
    MomentWidget(),
    ChatPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton:
          MyFloatingActionButton(onItemTapped, _selectedIndex),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class MyFloatingActionButton extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex; // 現在の選択されているインデックス

  MyFloatingActionButton(this.onItemTapped, this.selectedIndex);
  @override
  Widget build(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.up,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // 各FloatingActionButtonでの遷移処理
        FloatingActionButton(
          shape: CircleBorder(),
          heroTag: "search",
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 255, 17, 0),
          onPressed: () async {
            if (selectedIndex == 0) {
              uploadImageAndCreatePost();
              // Chat ボタンが選択されている場合の処理
            } else {
              onItemTapped(0);
            }
          },
        ),
        Container(
          margin: EdgeInsets.only(bottom: 18.0),
          child: FloatingActionButton(
            shape: CircleBorder(),
            heroTag: "history",
            child: const Icon(Icons.photo, color: Colors.white),
            backgroundColor: Color.fromARGB(105, 255, 255, 255),
            onPressed: () {
              if (selectedIndex == 2) {
                onItemTapped(0);
                // Chat ボタンが選択されている場合の処理
              } else {
                onItemTapped(2);
              }
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 18.0),
          child: FloatingActionButton(
            shape: CircleBorder(),
            heroTag: "chat",
            child: const Icon(Icons.message, color: Colors.white),
            backgroundColor: Color.fromARGB(105, 255, 255, 255),
            onPressed: () {
              if (selectedIndex == 1) {
                onItemTapped(0);
                // Chat ボタンが選択されている場合の処理
              } else {
                onItemTapped(1);
              }
            },
          ),
        ),
      ],
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