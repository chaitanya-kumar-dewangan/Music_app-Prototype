import 'package:cinestreamtunes/screens/home.dart';
import 'package:cinestreamtunes/services/player_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Native splash is kept until FlutterNativeSplash.remove() is called
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => YoutubePlayerProvider()),
      ],
      child: const MyApp(),
    ),
  );
  FlutterNativeSplash.remove(); // <-- Now remove splash AFTER delay
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cine Stream Tunes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CinestreamtunesHome(), // <- New screen that delays
    );
  }
}
