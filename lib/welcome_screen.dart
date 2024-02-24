import 'package:ansan/auth/login_screen.dart';
import 'package:ansan/auth/register_screen.dart';
import 'package:ansan/util/chat_bot/chat_bot_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Widget _buildModalSheet(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        FilledButton(
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) {
                return const LoginScreen();
              }),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.primary,
            ),
            fixedSize: MaterialStateProperty.all(
              Size(
                MediaQuery.of(context).size.width * 0.88,
                48,
              ),
            ),
          ),
          child: Text(
            "Login",
            style: GoogleFonts.poppins(),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) {
                return const RegisterScreen();
              }),
            );
          },
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
              Size(
                MediaQuery.of(context).size.width * 0.88,
                48,
              ),
            ),
          ),
          child: Text(
            "Sign Up",
            style: GoogleFonts.poppins(),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) {
                return const ChatBotScreen();
              }),
            );
          },
          style: ButtonStyle(
            side: MaterialStateProperty.all(
              BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            fixedSize: MaterialStateProperty.all(
              Size(
                MediaQuery.of(context).size.width * 0.88,
                48,
              ),
            ),
          ),
          icon: Icon(
            Icons.lightbulb_rounded,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          label: Text(
            "More about Glaucoma",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo.png",
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.32,
                ),
                Text(
                  "Welcome to",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Amrita Netra SamrakshaN",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.habibi(
                    textStyle: Theme.of(context).textTheme.titleLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "System",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.habibi(
                    textStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          BottomSheet(
            onClosing: () {},
            enableDrag: false,
            showDragHandle: false,
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            builder: _buildModalSheet,
          ),
        ],
      ),
    );
  }
}
