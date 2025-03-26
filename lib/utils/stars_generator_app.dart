import 'package:flutter/material.dart';
import 'generate_stars.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StarsGeneratorApp());
}

class StarsGeneratorApp extends StatelessWidget {
  const StarsGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<void>(
          future: generateStarsImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return const Center(
                child: Text('Stars background generated successfully!'),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
