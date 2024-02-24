import 'package:ansan/Doctor/profile/profile_screen.dart';
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
import 'package:google_fonts/google_fonts.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
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
                          return DoctorProfileScreen(
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lightbulb,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Know your patients better!",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Divider(
                                thickness: 1,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Enter the Patient ID of the patient to see their reports, or to add a new report or review a report and view/complete the questionnaire for them.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
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
