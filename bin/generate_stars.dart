import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../lib/utils/generate_stars.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await generateStarsImage();
  print('Stars background image generated successfully!');
}
