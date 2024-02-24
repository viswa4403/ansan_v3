import 'package:ansan/frontline_worker/profile/profile_screen.dart';
import 'package:ansan/util/chat_bot/chat_bot_screen.dart';
import 'package:ansan/util/home/patients_component.dart';
import 'package:ansan/util/home/welcome_container.dart';
import 'package:ansan/util/loading_screen.dart';
import 'package:ansan/util/toast_message.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FrontlineWorkerHomeScreen extends StatefulWidget {
  const FrontlineWorkerHomeScreen({super.key});

  @override
  State<FrontlineWorkerHomeScreen> createState() =>
      _FrontlineWorkerHomeScreenState();
}

class _FrontlineWorkerHomeScreenState extends State<FrontlineWorkerHomeScreen> {
  String userName = "", userRole = "U";

  Map<String, dynamic> userData = {};
  bool _isLoading = true;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    if (FirebaseAuth.instance.currentUser == null) {
      showToast("You are not logged in yet. Please login first.");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
        (route) => false,
      );
    } else {
      final db = FirebaseFirestore.instance;

      db
          .collection("userData")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          setState(() {
            userData = doc.data() as Map<String, dynamic>;
          });
        } else {
          showToast("Profile data not found. Please try again later.");
        }
      }).catchError((e) {
        showToast("Error: $e");
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _isLoading == true
          ? const LoadingScreen()
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: false,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(builder: (context) {
                          return FrontlineWorkerProfileScreen(
                            userData: userData,
                          );
                        }),
                      );
                    },
                    icon: Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) {
                              return const ChatBotScreen();
                            },
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.lightbulb_rounded,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ),
                            (route) => false,
                          );
                        });
                      },
                      icon: Icon(
                        Icons.logout_rounded,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HomeScreenWelcomeContainer(
                          userName: userData["userName"] ?? "",
                          userRole: userData["userRole"] ?? "A",
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        PatientsComponent(userData: userData),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
