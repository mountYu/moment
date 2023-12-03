import 'dart:math' as math;

import 'package:flame/palette.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:http/http.dart' as http;
import 'package:flame/components.dart';
import 'dart:ui' as ui;

class Ball extends BodyComponent with ContactCallbacks {
  late final String imageUrl;

  late Paint originalPaint;
  bool giveNudge = false;
  final double radius;
  final Vector2 _position;
  double _timeSinceNudge = 0.0;
  static const double _minNudgeRest = 2.0;
  static const double _minVelocityThreshold = 14.0;

  Ball(this._position, {this.radius = 20, required this.imageUrl});

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

  late ui.Image _image;

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
      ..friction = 0.05;
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

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final imageData = await _fetchImageData(imageUrl);

    _image = await _decodeImage(imageData);
  }

  Future<Uint8List> _fetchImageData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<ui.Image> _decodeImage(Uint8List imageData) async {
    return await decodeImageFromList(imageData);
  }

  @override
  void render(Canvas canvas) {
    if (_image != null) {
      super.render(canvas);

      // 画像の描画位置をボディの位置に合わせる
      final position = body.position;
      final scaleX = 80 / _image.width;
      final scaleY = 80 / _image.height;
      // print(scaleX);
      final matrix = Matrix4.identity()
        ..translate(position.x * 0 + 40, position.y * 0 + 40)
        ..rotateZ(0)
        ..scale(scaleX, scaleY); // スケーリングを追加

// ImageShaderを使用して画像を描画
      final paint = Paint()
        ..shader = ImageShader(
          _image,
          TileMode.repeated,
          TileMode.repeated,
          matrix.storage,
        );

      // 角が丸い矩形を定義
      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: 80,
          height: 80,
        ),
        const Radius.circular(20), // ここで角の丸みを設定
      );

      // 角が丸い矩形に画像を適用して描画
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    // このオブジェクトまたは他のオブジェクトの速度が閾値以上であるかどうかを確認
    if (body.linearVelocity.length >= _minVelocityThreshold ||
        (other as dynamic).body.linearVelocity.length >=
            _minVelocityThreshold) {
      HapticFeedback.lightImpact(); // 速度閾値を超える衝突を検出
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
