import 'package:ansan/admin/medical_history/all_history.dart';
import 'package:ansan/admin/medical_history/new_mh_screen.dart';
import 'package:ansan/admin/patients/patient_take_test.dart';
import 'package:ansan/admin/patients/patient_test_results.dart';
import 'package:ansan/doctor/medical_history/all_history.dart';
import 'package:ansan/doctor/medical_history/new_mh_screen.dart';
import 'package:ansan/doctor/patients/patient_test_results.dart';
import 'package:ansan/frontline_worker/medical_history/all_history.dart';
import 'package:ansan/frontline_worker/medical_history/new_mh_screen.dart';
import 'package:ansan/frontline_worker/patients/patient_take_test.dart';
import 'package:ansan/frontline_worker/patients/patient_test_results.dart';
import 'package:ansan/hshead/medical_history/all_history.dart';
import 'package:ansan/hshead/medical_history/new_mh_screen.dart';
import 'package:ansan/hshead/patients/patient_take_test.dart';
import 'package:ansan/hshead/patients/patient_test_results.dart';
import 'package:ansan/user/test_results/patient_take_test.dart';
import 'package:ansan/user/test_results/patient_test_results.dart';
import 'package:ansan/util/loading_screen.dart';
import 'package:ansan/util/toast_message.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewPatientScreen extends StatefulWidget {
  const ViewPatientScreen(
      {super.key, required this.patientId, required this.userData});

  final String patientId;
  final Map<String, dynamic> userData;

  @override
  State<ViewPatientScreen> createState() => _ViewPatientScreenState();
}

class _ViewPatientScreenState extends State<ViewPatientScreen> {
  bool _isLoading = true;
  Map<String, dynamic> patientData = {};

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

      db.collection("userData").doc(widget.patientId).get().then((doc) {
        if (doc.exists) {
          setState(() {
            patientData = doc.data() as Map<String, dynamic>;
          });
        } else {
          showToast("Patient data not found.");
          Navigator.of(context).pop();
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
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.72,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  "Patient Information",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.titleMedium,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  patientData["userName"],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.titleLarge,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                patientData["userGender"] == "M"
                                    ? "Male"
                                    : patientData["userGender"] == "F"
                                        ? "Female"
                                        : "Other",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.72,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant),
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
                                "Born on ${patientData["userDob"]}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                "Aadhar ${patientData["userAadhar"]}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                patientData["userEmail"] ?? "Email not given",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              Text(
                                patientData["phoneNumber"] ??
                                    "Phone Number not given",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              const Divider(
                                thickness: 1,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                patientData["userAddress"] ??
                                    "Address not given",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        if (patientData["numberOfQuestionnairesTaken"] > 0) ...[
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
                                  "Patient medical history is available. You can view it.",
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
                                          switch (widget.userData["userRole"]) {
                                            case "A":
                                              return AdminAllHistoryScreen(
                                                patientData: patientData,
                                                userData: widget.userData,
                                              );
                                            case "D":
                                              return DoctorAllHistoryScreen(
                                                patientData: patientData,
                                                userData: widget.userData,
                                              );
                                            case "H":
                                              return HsHeadAllHistoryScreen(
                                                patientData: patientData,
                                                userData: widget.userData,
                                              );
                                            case "F":
                                              return FrontlineWorkerAllHistoryScreen(
                                                patientData: patientData,
                                                userData: widget.userData,
                                              );
                                            default:
                                              return const WelcomeScreen();
                                          }
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
                                          switch (widget.userData["userRole"]) {
                                            case "A":
                                              return AdminPatientNewMhScreen(
                                                patientData: patientData,
                                                userData: widget.userData,
                                              );
                                            case "D":
                                              return DoctorPatientNewMhScreen(
                                                patientData: patientData,
                                                userData: widget.userData,
                                              );
                                            case "H":
                                              return HsHeadPatientNewMhScreen(
                                                patientData: patientData,
                                                userData: widget.userData,
                                              );
                                            case "F":
                                              return FrontlineWorkerPatientNewMhScreen(
                                                patientData: patientData,
                                                userData: widget.userData,
                                              );
                                            default:
                                              return const WelcomeScreen();
                                          }
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
                                  "Please provide patient's medical history to take glaucoma checkup",
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
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) {
                                          switch (widget.userData["userRole"]) {
                                            case "A":
                                              return AdminPatientNewMhScreen(
                                                patientData: patientData,
                                                userData: widget.userData,
                                              );
                                            case "D":
                                              return DoctorPatientNewMhScreen(
                                                patientData: patientData,
                                                userData: widget.userData,
                                              );
                                            case "F":
                                              return FrontlineWorkerPatientNewMhScreen(
                                                patientData: patientData,
                                                userData: widget.userData,
                                              );
                                            case "H":
                                              return HsHeadPatientNewMhScreen(
                                                patientData: patientData,
                                                userData: widget.userData,
                                              );
                                            default:
                                              return const WelcomeScreen();
                                          }
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
                        if (patientData["numberOfQuestionnairesTaken"] > 0) ...[
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
                                  "Patient has taken the questionnaire. You can now take glaucoma tests.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                if (widget.userData["userRole"] != "D") ...[
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      // TODO: Redirect to the glaucoma test screen

                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) {
                                        switch (widget.userData["userRole"]) {
                                          case "A":
                                            return AdminPatientTakeTestScreen(
                                              userData: widget.userData,
                                              patientId: widget.patientId,
                                            );
                                          case "H":
                                            return HsHeadPatientTakeTestScreen(
                                              userData: widget.userData,
                                              patientId: widget.patientId,
                                            );
                                          case "F":
                                            return FrontlineWorkerPatientTakeTestScreen(
                                              userData: widget.userData,
                                              patientId: widget.patientId,
                                            );
                                          case "U":
                                            return UserPatientTakeTestScreen(
                                              userData: widget.userData,
                                              patientId: widget.patientId,
                                            );
                                          default:
                                            return const WelcomeScreen();
                                        }
                                      }));
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
                                ],
                                if (patientData["numberOfTests"] > 0) ...[
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      // TODO: Redirect to the glaucoma reports screen

                                      Navigator.of(context).push(
                                          CupertinoPageRoute(
                                              builder: (context) {
                                        switch (widget.userData["userRole"]) {
                                          case "A":
                                            return AdminPatientTestResultsScreen(
                                              userData: widget.userData,
                                              patientData: patientData,
                                            );
                                          case "D":
                                            return DoctorPatientTestResultsScreen(
                                              userData: widget.userData,
                                              patientData: patientData,
                                            );
                                          case "F":
                                            return FrontlineWorkerPatientTestResultsScreen(
                                              userData: widget.userData,
                                              patientData: patientData,
                                            );
                                          case "H":
                                            return HsHeadPatientTestResultsScreen(
                                              userData: widget.userData,
                                              patientData: patientData,
                                            );
                                          case "U":
                                            return UserPatientTestResultsScreen(
                                              userData: widget.userData,
                                              patientData: patientData,
                                            );
                                          default:
                                            return const WelcomeScreen();
                                        }
                                      }));
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
                                      "View Glaucoma Reports",
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
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(
                          height: 48,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
