import 'package:ansan/user/family_member/family_members_screen.dart';
import 'package:ansan/user/family_member/new_family_member_screen.dart';
import 'package:ansan/user/profile/profile_screen.dart';
import 'package:ansan/user/questionnaire/all_history_screen.dart';
import 'package:ansan/user/questionnaire/the_form_screen.dart';
import 'package:ansan/user/test_results/patient_take_test.dart';
import 'package:ansan/user/test_results/patient_test_results.dart';
import 'package:ansan/util/chat_bot/chat_bot_screen.dart';
import 'package:ansan/util/home/welcome_container.dart';
import 'package:ansan/util/loading_screen.dart';
import 'package:ansan/util/toast_message.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
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
                          return UserProfileScreen(
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
                      horizontal: 16.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HomeScreenWelcomeContainer(
                          userName: userData["userName"] ?? "",
                          userRole: userData["userRole"] ?? "U",
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        if (userData["numberOfQuestionnairesTaken"] > 0) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "You have filled your medical history.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) {
                                          return UserAllMedicalHistory(
                                            userData: userData,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                    fixedSize: MaterialStateProperty.all(
                                      Size(
                                        MediaQuery.of(context).size.width *
                                            0.88,
                                        48,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "View Medical History",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) {
                                          return const UserQuestionnaireForm();
                                        },
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                      Size(
                                        MediaQuery.of(context).size.width *
                                            0.88,
                                        48,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Update Medical History",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .errorContainer
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Please provide your medical history to take glaucoma checkup",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onErrorContainer,
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                FilledButton(
                                  onPressed: () {
                                    // TODO: Redirect to the questionnaire screen

                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) {
                                          return const UserQuestionnaireForm();
                                        },
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.error,
                                    ),
                                    fixedSize: MaterialStateProperty.all(
                                      Size(
                                        MediaQuery.of(context).size.width *
                                            0.88,
                                        48,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Fill Up Medical History",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onError,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(
                          height: 16,
                        ),
                        // Manage Family Members
                        if (userData["numberOfFamilyMembers"] > 0) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "You have added ${userData["numberOfFamilyMembers"]} family members.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (context) {
                                              return UserFamilyMembersScreen(
                                                userData: userData,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Theme.of(context).colorScheme.primary,
                                        ),
                                        fixedSize: MaterialStateProperty.all(
                                          Size(
                                            MediaQuery.of(context).size.width *
                                                0.64,
                                            48,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "View Family Members",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (context) {
                                              return UserNewFamilyScreen(
                                                userData: userData,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        Icons.add_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "You have not added any family members yet.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) {
                                          return UserNewFamilyScreen(
                                            userData: userData,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                    fixedSize: MaterialStateProperty.all(
                                      Size(
                                        MediaQuery.of(context).size.width *
                                            0.88,
                                        48,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Add Family Members",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(
                          height: 16,
                        ),
                        if (userData["numberOfQuestionnairesTaken"] > 0) ...[
                          // Note that only after completing the questionnaire, the user can take glaucoma tests
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 16.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "You have taken the questionnaire. You can now take glaucoma tests.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                FilledButton(
                                  onPressed: () {
                                    // TODO: Redirect to the glaucoma test screen

                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) {
                                          return UserPatientTakeTestScreen(
                                            userData: userData,
                                            patientId: userData["userId"],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                    fixedSize: MaterialStateProperty.all(
                                      Size(
                                        MediaQuery.of(context).size.width *
                                            0.88,
                                        48,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Take Glaucoma Test",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                if (userData["numberOfTests"] > 0) ...[
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      // TODO: Redirect to the glaucoma test results screen

                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (context) {
                                            return UserPatientTestResultsScreen(
                                              userData: userData,
                                              patientData: userData,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.primary,
                                      ),
                                      fixedSize: MaterialStateProperty.all(
                                        Size(
                                          MediaQuery.of(context).size.width *
                                              0.88,
                                          48,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "View Test Results",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
