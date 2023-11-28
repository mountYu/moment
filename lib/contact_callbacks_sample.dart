import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:flame/game.dart';
import 'dart:async';
import 'balls.dart';

import 'boundaries.dart';
import 'generate_post.dart';

final countMoment = StateProvider((ref) {
  return 0;
});

class MomentWidget extends ConsumerWidget {
  const MomentWidget({Key? key}) : super(key: key);
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(countMoment);
    return Scaffold(
      body: GameWidget(
        game: ContactCallbacksSample(),
        backgroundBuilder: (context) => Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.w100,
                color: Color.fromARGB(255, 198, 198, 198),
              ),
            ),
            const Text(
              'Moment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 198, 198, 198),
              ),
            ),
          ],
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ここにアクションを記述
          print('buttonPushed');
          uploadImageAndCreatePost();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class ContactCallbacksSample extends Forge2DGame with TapDetector {
  int momentCounter = 0;
  StreamSubscription? _gyroscopeSubscription;
  ContactCallbacksSample() : super(gravity: Vector2(0, 70.0));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);
    // ジャイロスコープのリスナーを開始
    final stream =
        await SensorManager().sensorUpdates(sensorId: Sensors.ACCELEROMETER);
    // ジャイロスコープの値に基づいて重力を更新
    _gyroscopeSubscription = stream.listen((SensorEvent event) {
      final Vector2 newGravity = Vector2(event.data[0], -event.data[1]) * 100.0;
      world.gravity = newGravity;
    });
  }

  @override
  void onTapDown(TapDownInfo details) {
    super.onTapDown(details);
    final Vector2 position = details.eventPosition.global;
    HapticFeedback.mediumImpact();
    add(Ball(position));
    momentCounter += 1;
    // ref.read(countMoment.notifier).state++;
  }

  @override
  void onDetach() {
    // ジャイロスコープのリスナーをキャンセル
    _gyroscopeSubscription?.cancel();
    super.onDetach();
  }
}

// FloatingActionButtonのonPressedメソッド
