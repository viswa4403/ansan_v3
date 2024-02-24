import 'package:ansan/admin/patients/new_patient_screen.dart';
import 'package:ansan/admin/patients/patient_screen.dart';
import 'package:ansan/doctor/patients/patient_screen.dart';
import 'package:ansan/frontline_worker/patients/new_patient_screen.dart';
import 'package:ansan/frontline_worker/patients/patient_screen.dart';
import 'package:ansan/hshead/patients/new_patient_screen.dart';
import 'package:ansan/hshead/patients/patient_screen.dart';
import 'package:ansan/util/helper.dart';
import 'package:ansan/util/loading_screen.dart';
import 'package:ansan/util/toast_message.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllPatientsAddedByMeScreen extends StatefulWidget {
  const AllPatientsAddedByMeScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<AllPatientsAddedByMeScreen> createState() =>
      _AllPatientsAddedByMeScreenState();
}

class _AllPatientsAddedByMeScreenState
    extends State<AllPatientsAddedByMeScreen> {
  List<Map<String, dynamic>> patientsData = [];

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
          .where(
            Filter.and(
              Filter(
                "addedBy",
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              ),
              Filter(
                "userRole",
                isEqualTo: "U",
              ),
            ),
          )
          .get()
          .then((querySnapshot) {
        setState(() {
          patientsData = querySnapshot.docs.map((e) => e.data()).toList();
        });
      }).catchError((e) {
        debugPrint("Error: $e");
        showToast("Something went wrong. Please try again later.");
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }

    super.initState();
  }

  Widget officialCard(int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) {
              switch (widget.userData["userRole"]) {
                case "A":
                  return AdminPatientScreen(
                    userData: widget.userData,
                    patientId: patientsData[index]["userId"],
                  );
                case "D":
                  return DoctorPatientScreen(
                    userData: widget.userData,
                    patientId: patientsData[index]["userId"],
                  );
                case "F":
                  return FrontlineWorkerPatientScreen(
                    userData: widget.userData,
                    patientId: patientsData[index]["userId"],
                  );
                case "H":
                  return HsHeadPatientScreen(
                    userData: widget.userData,
                    patientId: patientsData[index]["userId"],
                  );
                default:
                  return const WelcomeScreen();
              }
            },
          ),
        );
      },
      borderRadius: BorderRadius.circular(16.0),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.secondaryContainer,
              width: 1.0,
            ),
          ),
          visualDensity: VisualDensity.comfortable,
          dense: true,
          title: Text(
            "${patientsData[index]["userName"]}",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.titleMedium,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            textAlign: TextAlign.start,
          ),
          subtitle: Text(
            "${Helper().humanReadableAgoTime(patientsData[index]["createdAt"])}, ${patientsData[index]["userGender"] == "M" ? "Male" : patientsData[index]["userGender"] == "F" ? "Female" : "Other"}",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodySmall,
              color: Theme.of(context).colorScheme.secondary,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
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
                  floating: true,
                  snap: true,
                  pinned: true,
                  centerTitle: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  expandedHeight: MediaQuery.of(context).size.height * 0.16,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 8.0,
                    ),
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    background: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32.0),
                        bottomRight: Radius.circular(32.0),
                      ),
                      child: Image.asset(
                        "assets/ansan_1.jpg",
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        "Patients",
                        style: GoogleFonts.habibi(
                          textStyle: Theme.of(context).textTheme.headlineSmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (patientsData.isEmpty) ...[
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
                                  "No patients added by you yet. Please add patient by clicking the button below.",
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
                                      MaterialPageRoute(
                                        builder: (context) {
                                          switch (widget.userData["userRole"]) {
                                            case "A":
                                              return AdminNewPatientScreen(
                                                userData: widget.userData,
                                              );
                                            case "F":
                                              return FrontlineWorkerNewPatientScreen(
                                                userData: widget.userData,
                                              );
                                            case "H":
                                              return HsHeadNewPatientScreen(
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
                                    "Add Patient",
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
                        ] else ...[
                          ListView.builder(
                            itemCount: patientsData.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0.0,
                              vertical: 16.0,
                            ),
                            itemBuilder: (context, index) {
                              return officialCard(index);
                            },
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
