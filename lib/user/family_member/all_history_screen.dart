import 'package:ansan/user/family_member/new_family_member_screen.dart';
import 'package:ansan/util/helper.dart';
import 'package:ansan/util/loading_screen.dart';
import 'package:ansan/util/toast_message.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FamilyMemberAllMedicalHistory extends StatefulWidget {
  const FamilyMemberAllMedicalHistory({
    super.key,
    required this.familyMemberData,
    required this.userData,
  });

  final Map<String, dynamic> familyMemberData, userData;

  @override
  State<FamilyMemberAllMedicalHistory> createState() =>
      _FamilyMemberAllMedicalHistoryState();
}

class _FamilyMemberAllMedicalHistoryState
    extends State<FamilyMemberAllMedicalHistory> {
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
          .doc(widget.familyMemberData["userId"])
          .collection("medicalHistory")
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

  Widget _historyDataWidget(int index) {
    /*
    "height": controllers[0].text.toString(),
        "weight": controllers[1].text.toString(),
        "covidVaccination": controllers[2].text.toString(),
        "anyAllergies": controllers[3].text.toString(),
        "allergies": controllers[4].text.toString(),
        "symptoms": controllers[5].text.toString(),
        "symptomDuration": controllers[6].text.toString(),
        "injury": controllers[7].text.toString(),
        "medication": controllers[8].text.toString(),
        "medicalHistory": controllers[9].text.toString(),
        "consumptions": controllers[10].text.toString(),
        "familyHistory": controllers[11].text.toString(),
        // Lvl 2
        "redness": controllers[12].text.toString(),
        "pain": controllers[13].text.toString(),
        "halos": controllers[14].text.toString(),
        "suddenExacerbation": controllers[15].text.toString(),
        "consulted": controllers[16].text.toString(),
        "medicines": controllers[17].text.toString(),
        "generalInvestigation": controllers[18].text.toString(),
        "diabeticRetinopathy": controllers[19].text.toString(),
        "macularDegenerations": controllers[20].text.toString(),
        "macularhole": controllers[21].text.toString(),
        "glaucoma": controllers[22].text.toString(),
        "catract": controllers[23].text.toString(),
        "uveitis": controllers[24].text.toString(),
        "fundusPhotography": controllers[25].text.toString(),
        "fundusAngiography": controllers[26].text.toString(),
        "opticalCoherenceTomography": controllers[27].text.toString(),
        "visualFieldAnalysis": controllers[28].text.toString(),
        "gonioscopy": controllers[29].text.toString(),
        "centralCornealThicknessAnalysis": controllers[30].text.toString(),
        "slitLampInvestigation": controllers[31].text.toString(),
        "applanationTonometry": controllers[32].text.toString(),
        "bScan": controllers[33].text.toString(),
        "biochemicalParameters": controllers[34].text.toString(),
        "createdAt": FieldValue.serverTimestamp(),
        "createdBy": FirebaseAuth.instance.currentUser!.uid,
    */

    final dataToShow = [
      {
        "questionLabel": "Please enter your height in cm",
        "answer": _allHistoryData[index]["height"],
      },
      {
        "questionLabel": "Please enter your weight in kg",
        "answer": _allHistoryData[index]["weight"],
      },
      {
        "questionLabel": "Please select your COVID vaccination status",
        "answer": _allHistoryData[index]["covidVaccination"],
      },
      {
        "questionLabel": "Do you have any allergies?",
        "answer": _allHistoryData[index]["anyAllergies"],
      },
      {
        "questionLabel": "Please enter your allergies",
        "answer": _allHistoryData[index]["allergies"],
      },
      {
        "questionLabel": "Please enter symptoms observed. (Enter NIL if none)",
        "answer": _allHistoryData[index]["symptoms"],
      },
      {
        "questionLabel":
            "How long have you been experiencing symptoms? (Enter NIL if none)",
        "answer": _allHistoryData[index]["symptomDuration"],
      },
      {
        "questionLabel": "Any accidents or injuries?",
        "answer": _allHistoryData[index]["injury"],
      },
      {
        "questionLabel":
            "Any long term medication? Please specify. (Enter NIL if none)",
        "answer": _allHistoryData[index]["medication"],
      },
      {
        "questionLabel": "Any past medical history.",
        "answer": _allHistoryData[index]["medicalHistory"],
      },
      {
        "questionLabel": "Other consumptions.",
        "answer": _allHistoryData[index]["consumptions"],
      },
      {
        "questionLabel": "Family History",
        "answer": _allHistoryData[index]["familyHistory"],
      },
      {
        "questionLabel": "Do you face Redness of eye?",
        "answer": _allHistoryData[index]["redness"],
      },
      {
        "questionLabel": "Do you face pain in eye?",
        "answer": _allHistoryData[index]["pain"],
      },
      {
        "questionLabel": "Do you see halos around lights?",
        "answer": _allHistoryData[index]["halos"],
      },
      {
        "questionLabel": "Any time you had sudden exacerbation of the problem?",
        "answer": _allHistoryData[index]["suddenExacerbation"],
      },
      {
        "questionLabel": "Did you show to any doctor for this problem?",
        "answer": _allHistoryData[index]["consulted"],
      },
      {
        "questionLabel": "Have you been taking any medicines for this problem?",
        "answer": _allHistoryData[index]["medicines"],
      },
      {
        "questionLabel": "Any general investigations you have got done?",
        "answer": _allHistoryData[index]["generalInvestigation"],
      },
      {
        "questionLabel": "Do you have diabetic retinopathy?",
        "answer": _allHistoryData[index]["diabeticRetinopathy"],
      },
      {
        "questionLabel": "Do you have macular degenerations?",
        "answer": _allHistoryData[index]["macularDegenerations"],
      },
      {
        "questionLabel": "Do you have macular hole?",
        "answer": _allHistoryData[index]["macularhole"],
      },
      {
        "questionLabel": "Do you have glaucoma?",
        "answer": _allHistoryData[index]["glaucoma"],
      },
      {
        "questionLabel": "Do you have cataract?",
        "answer": _allHistoryData[index]["catract"],
      },
      {
        "questionLabel": "Do you have uveitis?",
        "answer": _allHistoryData[index]["uveitis"],
      },
      {
        "questionLabel": "Have you got Fundus Photography investigations?",
        "answer": _allHistoryData[index]["fundusPhotography"],
      },
      {
        "questionLabel": "Have you got Fundus Angiography investigations?",
        "answer": _allHistoryData[index]["fundusAngiography"],
      },
      {
        "questionLabel":
            "Have you got Optical Coherence Tomography investigations?",
        "answer": _allHistoryData[index]["opticalCoherenceTomography"],
      },
      {
        "questionLabel": "Have you got Visual Field Analysis investigations?",
        "answer": _allHistoryData[index]["visualFieldAnalysis"],
      },
      {
        "questionLabel": "Have you got Gonioscopy investigations?",
        "answer": _allHistoryData[index]["gonioscopy"],
      },
      {
        "questionLabel":
            "Have you got Central Corneal Thickness Analysis investigations?",
        "answer": _allHistoryData[index]["centralCornealThicknessAnalysis"],
      },
      {
        "questionLabel": "Have you got Slit Lamp investigations?",
        "answer": _allHistoryData[index]["slitLampInvestigation"],
      },
      {
        "questionLabel": "Have you got Applanation Tonometry investigations?",
        "answer": _allHistoryData[index]["applanationTonometry"],
      },
      {
        "questionLabel": "Have you got B Scan investigations?",
        "answer": _allHistoryData[index]["bScan"],
      },
      {
        "questionLabel": "Have you got Biochemical Parameters investigations?",
        "answer": _allHistoryData[index]["biochemicalParameters"],
      },
    ];

    Widget renderQuestion() {
      return Column(
        children: [
          for (int i = 0; i < dataToShow.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: dataToShow[i]["questionLabel"],
                      labelStyle: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    controller: TextEditingController(
                      text: dataToShow[i]["answer"],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 32.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * 0.88,
              minHeight: MediaQuery.of(context).size.height * 0.12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              image: const DecorationImage(
                image: AssetImage("assets/ansan_1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  Text(
                    "Medical History",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.familyMemberData["userName"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    "${Timestamp.fromMicrosecondsSinceEpoch(
                      _allHistoryData[index]["createdAt"]
                          .microsecondsSinceEpoch,
                    ).toDate().day} ${DateFormat("MMMM").format(
                      Timestamp.fromMicrosecondsSinceEpoch(
                        _allHistoryData[index]["createdAt"]
                            .microsecondsSinceEpoch,
                      ).toDate(),
                    )} ${Timestamp.fromMicrosecondsSinceEpoch(
                      _allHistoryData[index]["createdAt"]
                          .microsecondsSinceEpoch,
                    ).toDate().year}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          renderQuestion(),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget medicalHistoryCard(int index) {
    return Padding(
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
        trailing: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              enableDrag: true,
              useSafeArea: true,
              isDismissible: true,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (context) {
                return _historyDataWidget(index);
              },
            );
          },
          child: Chip(
            avatar: const Icon(
              Icons.remove_red_eye_rounded,
              color: Colors.black,
            ),
            elevation: 1,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            side: const BorderSide(
              color: Colors.black,
            ),
            padding: const EdgeInsets.all(4.0),
            label: Text(
              "View",
              style: GoogleFonts.raleway(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
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
                        "Medical History",
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
                          widget.familyMemberData["userName"],
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
                                  "No medical history found for this year. Please add your medical history to view it here.",
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
                                          return UserNewFamilyScreen(
                                              userData: widget.userData);
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
                                    "Fill up Medical History",
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
