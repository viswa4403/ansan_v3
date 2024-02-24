import 'package:ansan/util/loading_screen.dart';
import 'package:ansan/util/toast_message.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FamilyMemberPatientResultScreen extends StatefulWidget {
  const FamilyMemberPatientResultScreen({
    super.key,
    required this.userData,
    required this.patientData,
    required this.reportId,
  });

  final Map<String, dynamic> userData, patientData;
  final String reportId;

  @override
  State<FamilyMemberPatientResultScreen> createState() =>
      _FamilyMemberPatientResultScreenState();
}

class _FamilyMemberPatientResultScreenState extends State<FamilyMemberPatientResultScreen> {
  bool _isLoading = true;

  Map<String, dynamic> reportData = {};

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
          .doc(widget.reportId)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            reportData = value.data() as Map<String, dynamic>;
          });

          setState(() {
            reportData["leftEyeResult"] > 0.5
                ? reportData["leftEyeResult"] = "Positive"
                : reportData["leftEyeResult"] = "Negative";
            reportData["rightEyeResult"] > 0.5
                ? reportData["rightEyeResult"] = "Positive"
                : reportData["rightEyeResult"] = "Negative";
          });
        } else {
          showToast("No report found for this patient.");
          Navigator.of(context).pop();
        }
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
                        "Patient Test Result",
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // Patient ID
                        const SizedBox(
                          height: 24,
                        ),
                        Chip(
                          padding: const EdgeInsets.all(2.0),
                          label: Text(
                            "Patient ID: ${widget.patientData["userId"]}",
                            style: GoogleFonts.sourceCodePro(
                              fontWeight: FontWeight.w500,
                              textStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        // disclaimer that the reports are predicted by the model and not by an actual doctor. Like a warning Card with icon
                        Card(
                          borderOnForeground: true,
                          color: Theme.of(context).colorScheme.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.warning_rounded,
                                      color:
                                          Theme.of(context).colorScheme.onError,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Disclaimer",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onError,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "These reports are predicted by an AI model and not by an actual doctor and only serve as a preliminary diagnosis.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        Card(
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2.0, vertical: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  widget.reportId,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.sourceCodePro(
                                    textStyle:
                                        Theme.of(context).textTheme.titleLarge,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                const Divider(
                                  height: 0,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Chip(
                                  label: Text(
                                    DateFormat.yMMMMd().format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                        reportData["createdAt"]
                                            .microsecondsSinceEpoch,
                                      ),
                                    ),
                                    style: GoogleFonts.sourceCodePro(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Divider(
                                  height: 0,
                                ),
                                // table with chips indicating the results
                                Table(
                                  border: TableBorder.symmetric(
                                    inside: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(0.3),
                                      width: 1.0,
                                    ),
                                  ),
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Right Eye",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Left Eye",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Chip(
                                              label: Text(
                                                reportData["rightEyeResult"],
                                                style:
                                                    GoogleFonts.sourceCodePro(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                  fontWeight: FontWeight.w500,
                                                  color: reportData[
                                                              "rightEyeResult"] ==
                                                          "Negative"
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onError,
                                                ),
                                              ),
                                              backgroundColor:
                                                  reportData["rightEye"] ==
                                                          "Negative"
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Chip(
                                              label: Text(
                                                reportData["leftEyeResult"],
                                                style:
                                                    GoogleFonts.sourceCodePro(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                  color: reportData[
                                                              "leftEyeResult"] ==
                                                          "Negative"
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onError,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              backgroundColor:
                                                  reportData["leftEyeResult"] ==
                                                          "Negative"
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 0,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),

                                for (int i = reportData["images"].length - 1;
                                    i > -1;
                                    i--) ...[
                                  Chip(
                                    label: Text(
                                      i == 0
                                          ? "Left Eye Image 1"
                                          : i == 1
                                              ? "Left Eye Image 2"
                                              : i == 2
                                                  ? "Right Eye Image 1"
                                                  : "Right Eye Image 2",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  ClipRect(
                                    child: Image.network(
                                      reportData["images"][i],
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width *
                                          0.84,
                                      filterQuality: FilterQuality.high,
                                      isAntiAlias: true,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        Card(
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.rate_review_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      "Doctor's Comments",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                  ],
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
                                if (reportData["doctorComments"] != "") ...[
                                  TextField(
                                    controller: TextEditingController(
                                      text: reportData["doctorComments"] ??
                                          "No comments yet.",
                                    ),
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      labelStyle: GoogleFonts.raleway(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer),
                                      ),
                                    ),
                                    readOnly: true,
                                    style: GoogleFonts.raleway(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                ] else ...[
                                  Text(
                                    "No comments yet.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.raleway(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        Card(
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2.0, vertical: 16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.84,
                                  child: ElevatedButton.icon(
                                    label: Text(
                                      "Download Report",
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.download_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 16.0),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onPressed: () {
                                      // TODO: Download the report as a PDF
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),

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
