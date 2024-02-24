import 'package:ansan/util/chat_bot/chat_bot_screen.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AnsanApp());
}

class AnsanApp extends StatelessWidget {
  const AnsanApp({super.key});

  static final _defaultLightColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.lightBlueAccent,
    brightness: Brightness.dark,
  );

  static final _defaultDarkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.lightBlueAccent,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "ANSAN",
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme ?? _defaultLightColorScheme,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          themeMode: ThemeMode.system,
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
