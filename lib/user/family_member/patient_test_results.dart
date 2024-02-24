import 'package:ansan/user/family_member/patient_test_result.dart';
import 'package:ansan/util/helper.dart';
import 'package:ansan/util/loading_screen.dart';
import 'package:ansan/util/toast_message.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FamilyMemberPatientResults extends StatefulWidget {
  const FamilyMemberPatientResults({
    super.key,
    required this.patientData,
    required this.userData,
  });

  final Map<String, dynamic> patientData, userData;

  @override
  State<FamilyMemberPatientResults> createState() => _FamilyMemberPatientResultsState();
}

class _FamilyMemberPatientResultsState extends State<FamilyMemberPatientResults> {
  List<Map<String, dynamic>> _allHistoryData = [];
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
          .doc(widget.patientData["userId"])
          .collection("reportData")
          .orderBy("createdAt", descending: true)
          .limit(10)
          .get()
          .then((querySnapshot) {
        setState(() {
          _allHistoryData = querySnapshot.docs.map((e) => e.data()).toList();
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

  Widget medicalHistoryCard(int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) {
            return FamilyMemberPatientResultScreen(
                userData: widget.userData,
                patientData: widget.patientData,
                reportId: _allHistoryData[index]["reportId"],
            );
          }),
        );
      },
      borderRadius: BorderRadius.circular(16.0),
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
          dense: true,
          title: Text(
            Helper().humanReadableAgoTime(
              Timestamp.fromMicrosecondsSinceEpoch(
                _allHistoryData[index]["createdAt"].microsecondsSinceEpoch,
              ),
            ),
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.titleMedium,
              color: Theme.of(context).colorScheme.secondary,
            ),
            textAlign: TextAlign.start,
          ),
          subtitle: Text(
            "${Timestamp.fromMicrosecondsSinceEpoch(_allHistoryData[index]["createdAt"].microsecondsSinceEpoch).toDate().day} ${DateFormat("MMMM").format(Timestamp.fromMicrosecondsSinceEpoch(_allHistoryData[index]["createdAt"].microsecondsSinceEpoch).toDate())}\n${Timestamp.fromMicrosecondsSinceEpoch(_allHistoryData[index]["createdAt"].microsecondsSinceEpoch).toDate().year}",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodySmall,
              color: Theme.of(context).colorScheme.secondary,
            ),
            textAlign: TextAlign.start,
          ),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            child: Text(
              DateFormat("dd").format(
                DateTime.fromMicrosecondsSinceEpoch(
                  _allHistoryData[index]["createdAt"].microsecondsSinceEpoch,
                ),
              ),
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.titleMedium,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
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
                        "Test Results",
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
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          widget.patientData["userName"],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.titleMedium,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        if (_allHistoryData.isEmpty) ...[
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
                                  "No test data found for this patient. Please take a test first.",
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
                                    Navigator.of(context).pop();
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
                                    "Go Back",
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
                            itemCount: _allHistoryData.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0.0,
                              vertical: 16.0,
                            ),
                            itemBuilder: (context, index) {
                              return medicalHistoryCard(index);
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
