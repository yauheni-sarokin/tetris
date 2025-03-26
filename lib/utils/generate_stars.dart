import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Future<void> generateStarsImage() async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final size = const Size(400, 400);
  final paint = Paint()..color = Colors.white;
  final random = Random();

  // Fill background with dark blue
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.width, size.height),
    Paint()..color = const Color(0xFF000020),
  );

  // Draw random stars
  for (var i = 0; i < 200; i++) {
    final x = random.nextDouble() * size.width;
    final y = random.nextDouble() * size.height;
    final radius = random.nextDouble() * 1.5;
    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();

  final file = File('assets/images/stars.png');
  await file.writeAsBytes(buffer);
}
