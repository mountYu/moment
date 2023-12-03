import 'package:flame/experimental.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:flame/game.dart';
import 'package:moment/views/chat_page.dart';
import 'package:moment/views/widget/change_color_dialog.dart';
import 'package:moment/views/widget/name.dart';
import 'dart:async';
import 'object/image_balls.dart';
import 'object/boundaries.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';
import '../connect_database/firestore_read.dart';

class ThemeColorNotifier extends StateNotifier<String> {
  ThemeColorNotifier() : super('0'); // デフォルトカラー

  void setThemeColor(String color) {
    state = color;
  }

  Future<void> loadThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('theme_color') ?? '0';
  }
}

final themeColorProvider =
    StateNotifierProvider<ThemeColorNotifier, String>((ref) {
  return ThemeColorNotifier();
});

final countMoment = StateProvider((ref) {
  return 0;
});

class MomentWidget extends ConsumerWidget {
  final user = FirebaseAuth.instance.currentUser!;
  MomentWidget({Key? key}) : super(key: key);

  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(countMoment);
    return Scaffold(
      body: GameWidget(
        game: ContactCallbacksSample(),
        backgroundBuilder: (context) => Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
            ),
            TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierColor:
                        Colors.black.withOpacity(0.8), // モーダルの外側の色と透明度を設定
                    builder: (BuildContext context) {
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
                                child: NameWidget(
                                    name: user.displayName!, fontsize: 50.0),
                              ),
                              SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: ListWheelScrollView(
                                    diameterRatio: 1.2,
                                    physics: FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      print("選択されたアイテム: $index");
                                    },
                                    itemExtent: 80.0,
                                    children: [
                                      Container(
                                        width: 70.0,
                                        height: 70.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 0, 0), // 円の色
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Container(
                                        width: 70.0,
                                        height: 70.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 0, 0, 255), // 円の色
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Container(
                                        width: 70.0,
                                        height: 70.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 0), // 円の色
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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
                    },
                  );
                },
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 80,
                    height: 1,
                    fontWeight: FontWeight.w100,
                    color: Color.fromARGB(255, 198, 198, 198),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'M',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 198, 198, 198),
                  ),
                ),
                const Text(
                  'o',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 255, 0, 0),
                  ),
                ),
                const Text(
                  'ment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 198, 198, 198),
                  ),
                ),
              ],
            )
          ],
        )),
      ),
    );
  }
}

class ContactCallbacksSample extends Forge2DGame {
  int momentCounter = 0;
  List<Ball> balls = []; // ボールのリスト
  StreamSubscription? _gyroscopeSubscription;
  Vector2 lastGravity = Vector2.zero(); // 最後に記録された重力
  final double velocityThreshold = 5.0; // 速度の閾値
  bool isPhysicsPaused = false; // 物理エンジンの更新状態
  final user = FirebaseAuth.instance.currentUser!;

  ContactCallbacksSample() : super(gravity: Vector2(0, 70.0));
  @override
  void update(double dt) {
    if (!isPhysicsPaused) {
      super.update(dt); // 物理エンジンの更新を実行
    }
    // それ以外の場合、更新をスキップ
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
    // ジャイロスコープのリスナーを開始
    final stream =
        await SensorManager().sensorUpdates(sensorId: Sensors.ACCELEROMETER);
    _gyroscopeSubscription = stream.listen((SensorEvent event) {
      final Vector2 newGravity = Vector2(event.data[0], -event.data[1]) * 100.0;
      if (lastGravity.distanceToSquared(newGravity) > 15.0 && isPhysicsPaused) {
        // 重力が大きく変わった場合、物理エンジンの更新を再開
        isPhysicsPaused = false;
      }
      lastGravity = newGravity;
      if (!isPhysicsPaused) world.gravity = newGravity;
    });
    try {
      List<Post> posts = await getUserPosts(user.uid);
      if (posts != null) {
        generateBallsFromPosts(posts);
      }
    } catch (e) {
      print('エラーが発生しました107: $e');
    }

    // 速度チェックの定期実行
    Timer.periodic(const Duration(seconds: 1), (_) => checkVelocity());

    // FirebaseFirestore.instance
    //     .collection('posts')
    //     .where('userId', isEqualTo: user.uid)
    //     .snapshots()
    //     .listen((snapshot) {
    //   for (var change in snapshot.docChanges) {
    //     if (change.type == DocumentChangeType.added) {
    //       // 新しい投稿が追加された
    //       var newPost = Post.fromFirestore(change.doc);
    //       _addNewBall(newPost);
    //     }
    //   }
    // });
  }

  //定期的にオブジェクトの最大速度をチェックして、すべてのボールが閾値以下の場合、物理エンジンの更新を停止
  void checkVelocity() {
    bool areAllBallsBelowThreshold = true;
    for (final ball in balls) {
      if (ball.body.linearVelocity.length >= velocityThreshold) {
        areAllBallsBelowThreshold = false;
        break;
      }
    }
    if (areAllBallsBelowThreshold) {
      isPhysicsPaused = true;
    }
  }

  void generateBallsFromPosts(List<Post> posts) async {
    final Vector2 position = Vector2(200, 15);
    try {
      List<Post>? posts = await getUserPosts(user.uid);
      for (var post in posts) {
        final ball = Ball(position, imageUrl: post.smallStorageUrl);
        balls.add(ball); // ボールリストに追加
        add(ball); // ゲームの世界にボールを追加
      }
    } catch (e) {
      print('エラーが発生しました144: $e');
    }
  }

  _addNewBall(Post post) async {
    final Vector2 position = Vector2(200, 15);
    final ball = Ball(position, imageUrl: post.smallStorageUrl);
    balls.add(ball); // ボールリストに追加
    add(ball); // ゲームの世界にボールを追加
  }

  @override
  void onDetach() {
    _gyroscopeSubscription?.cancel();
    super.onDetach();
  }
}

//ballがタップされた時の処理
//自分の画像の場合は画像がローカルに保存されている。
//他の人の画像の場合はオンラインから取得する。

