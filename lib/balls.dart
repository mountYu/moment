import 'dart:math' as math;
import 'package:forge2d/forge2d.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/contact_callbacks.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'dart:ui' as ui;

class Ball extends BodyComponent with ContactCallbacks {
  late Paint originalPaint;
  bool giveNudge = false;
  final double radius;
  final Vector2 _position;
  double _timeSinceNudge = 0.0;
  static const double _minNudgeRest = 2.0;
  static const double _minVelocityThreshold = 12.0;

  Ball(this._position, {this.radius = 20}) {
    originalPaint = randomPaint();
  }

  Paint randomPaint() {
    final rng = math.Random();
    return PaletteEntry(
      Color.fromARGB(
        100 + rng.nextInt(155),
        100 + rng.nextInt(155),
        100 + rng.nextInt(155),
        255,
      ),
    ).paint();
  }

  int width = 80;
  int height = 80;
  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: _position,
      userData: this,
    );

    // ... bodyの形状やフィクスチャを定義 ...
    final body = world.createBody(bodyDef);

    // 八角形の中心部分を作成
    final polygonShape = PolygonShape();
    // 中心位置を (0, 0) に、回転角度を 0 に設定して四角形を定義
    polygonShape.setAsBox(width / 2 - 10, height / 2 - 10, Vector2.zero(), 0);
    // 八角形の各頂点を個別に指定
    List<Vector2> vertices = [
      Vector2(-40.0, 20.0),
      Vector2(-40.0, -20.0),
      Vector2(-20.0, -40.0),
      Vector2(20.0, -40.0),
      Vector2(40.0, -20.0),
      Vector2(40.0, 20.0),
      Vector2(20.0, 40.0),
      Vector2(-20.0, 40.0)
    ];

    polygonShape.set(vertices);
    final centerFixtureDef = FixtureDef(polygonShape)
      ..restitution = 0.8
      ..density = 1.0
      ..friction = 0.1;
    body.createFixture(centerFixtureDef);

    // 各角に円形のフィクスチャを追加
    const cornerRadius = 20.0;
    final List<Vector2> cornerPositions = [
      Vector2(-width / 2 + cornerRadius, -height / 2 + cornerRadius), // 左上
      Vector2(width / 2 - cornerRadius, -height / 2 + cornerRadius), // 右上
      Vector2(width / 2 - cornerRadius, height / 2 - cornerRadius), // 右下
      Vector2(-width / 2 + cornerRadius, height / 2 - cornerRadius), // 左下
    ];

    for (final cornerPosition in cornerPositions) {
      // 新しいShapeインスタンスを作成
      final cornerShape = CircleShape()
        ..radius = cornerRadius
        ..position.setFrom(cornerPosition); // 角の位置を設定

      final cornerFixtureDef = FixtureDef(cornerShape)
        ..restitution = 0.8
        ..density = 1.0
        ..friction = 0.1;

      // 同じボディに角のフィクスチャを追加
      body.createFixture(cornerFixtureDef);
    }

    return body;
  }

  late ui.Image _image;
  late final Paint _paint;
  // balls.dartの修正部分
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _image = await Flame.images.load('app1.png');
    // 画像を塗りつぶしに使用するためのPaintを作成
    _paint = Paint()
      ..shader = ImageShader(
        _image,
        TileMode.clamp,
        TileMode.clamp,
        Matrix4.identity().scaled(1.0).storage,
      );
  }

  // @override
  // void render(Canvas canvas) {
  //   super.render(canvas);

  //   // forge2dのワールド座標をスクリーン座標に変換
  //   final screenPosition = body.position;
  //   // 画像の左上の座標を計算
  //   final Offset imageTopLeft = Offset(
  //     screenPosition.x - (width / 2),
  //     screenPosition.y - (height / 2),
  //   );

  //   // 宛先の矩形を作成
  //   final destinationRect = Rect.fromLTWH(
  //     imageTopLeft.dx,
  //     imageTopLeft.dy,
  //     width.toDouble(),
  //     height.toDouble(),
  //   );
  //   print('bodyから${screenPosition.y}、宛先${destinationRect}');

  // 元の画像サイズから新しいサイズへの矩形を定義
  // final sourceRect = Rect.fromLTWH(
  //   0,
  //   0,
  //   _image.width.toDouble(),
  //   _image.height.toDouble(),
  // );

  // // 元の画像から新しいサイズの矩形へと描画
  // canvas.drawImageRect(_image, sourceRect, destinationRect, _paint);
  // }

  @override
  void beginContact(Object other, Contact contact) {
    // 接触したオブジェクトが Ball クラスのインスタンスであるかどうかを確認
    if (other is Ball) {
      // 両方のオブジェクトの速度が閾値以下なら衝突を無視
      if (body.linearVelocity.length < _minVelocityThreshold &&
          (other as Ball).body.linearVelocity.length < _minVelocityThreshold) {
        return;
      } // 衝突を検出
      HapticFeedback.lightImpact(); // ボール同士の衝突を検出
    }
  }
  // Handle any other contacts if necessary

  @override
  void update(double t) {
    super.update(t);
    _timeSinceNudge += t;
    if (giveNudge) {
      giveNudge = false;
      if (_timeSinceNudge > _minNudgeRest) {
        body.applyLinearImpulse(Vector2(0, 1000));
        _timeSinceNudge = 0.0;
      }
    }
  }
}
