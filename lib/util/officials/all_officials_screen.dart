import 'package:ansan/admin/officials/new_official_screen.dart';
import 'package:ansan/hshead/officials/new_official_screen.dart';
import 'package:ansan/util/helper.dart';
import 'package:ansan/util/loading_screen.dart';
import 'package:ansan/util/toast_message.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllOfficialsScreen extends StatefulWidget {
  const AllOfficialsScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<AllOfficialsScreen> createState() => _AllOfficialsScreenState();
}

class _AllOfficialsScreenState extends State<AllOfficialsScreen> {
  List<Map<String, dynamic>> officialsData = [];

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
          .where(Filter.and(
              Filter("addedBy",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid),
              Filter("userRole", isNotEqualTo: "U")))
          .get()
          .then((querySnapshot) {
        setState(() {
          officialsData = querySnapshot.docs.map((e) => e.data()).toList();
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

  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //
  // final TextEditingController _userNameController = TextEditingController();
  // String? _gender, _userRole;
  // final TextEditingController _phoneNumberController = TextEditingController();

  Future<String> _toggleStatus(int index) async {
    setState(() {
      _isLoading = true;
    });

    if (FirebaseAuth.instance.currentUser?.uid == null) {
      showToast("You are not logged in yet. Please login first.");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
        (route) => false,
      );
    }

    try {
      final db = FirebaseFirestore.instance;

      if (FirebaseAuth.instance.currentUser != null) {
        final Map<String, dynamic> userData = {
          "userAccountStatus":
              officialsData[index]["userAccountStatus"] == "A" ? "I" : "A",
        };

        await db
            .collection("userData")
            .doc(officialsData[index]["userId"])
            .set(userData, SetOptions(merge: true))
            .onError((error, stackTrace) {
          debugPrint("Error updating user profile in Cloud Firestore: $error");
        });

        if (officialsData[index]["userAccountStatus"] == "A") {
          showToast("Account deactivated successfully.");
        } else {
          showToast("Account activated successfully.");
        }

        setState(() {
          officialsData[index]["userAccountStatus"] =
              officialsData[index]["userAccountStatus"] == "A" ? "I" : "A";
        });

        return "1";
      }
    } catch (e) {
      debugPrint(e.toString());
      showToast("Something went wrong. Please try again later.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    return "-1";
  }

  Widget _profileWidget(int index) {
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
              child: Text(
                "Profile",
                textAlign: TextAlign.center,
                style: GoogleFonts.habibi(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Chip(
            avatar: const Icon(
              Icons.verified_user_rounded,
              color: Colors.black,
              opticalSize: 2.0,
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
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 0.0,
            ),
            label: Text(
              Helper().roleToRoleName(officialsData[index]["userRole"]),
              style: GoogleFonts.raleway(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller:
                TextEditingController(text: officialsData[index]["userName"]),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Full Name",
              prefixIcon: const Icon(Icons.person_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller:
                TextEditingController(text: officialsData[index]["userEmail"]),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Email ID",
              prefixIcon: const Icon(Icons.email_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: TextEditingController(
              text: officialsData[index]["userGender"] == "M"
                  ? "Male"
                  : officialsData[index]["userGender"] == "F"
                      ? "Female"
                      : "Prefer Not to say",
            ),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Gender",
              prefixIcon: const Icon(Icons.wc_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: TextEditingController(
                text: officialsData[index]["phoneNumber"]),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Phone Number",
              prefixIcon: const Icon(Icons.phone_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget officialCard(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondaryContainer,
            width: 1.0,
          ),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondaryContainer,
            width: 1.0,
          ),
        ),
        visualDensity: VisualDensity.comfortable,
        collapsedBackgroundColor:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 6.0,
        ),
        dense: true,
        title: Text(
          "${officialsData[index]["userName"]}",
          style: GoogleFonts.raleway(
            textStyle: Theme.of(context).textTheme.titleMedium,
            color: Theme.of(context).colorScheme.secondary,
          ),
          textAlign: TextAlign.start,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Chip(
              avatar: officialsData[index]['userAccountStatus'] == "A"
                  ? const Icon(
                      Icons.verified_rounded,
                      color: Colors.black,
                      opticalSize: 2.0,
                    )
                  : const Icon(
                      Icons.gpp_bad_rounded,
                      color: Colors.black,
                      opticalSize: 1.0,
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
                officialsData[index]["userAccountStatus"] == "A"
                    ? "Active"
                    : "Inactive",
                style: GoogleFonts.raleway(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              backgroundColor: officialsData[index]["userAccountStatus"] == "A"
                  ? Colors.greenAccent
                  : Theme.of(context).colorScheme.error,
            ),
            const SizedBox(
              width: 8,
            ),
            Chip(
              avatar: const Icon(
                Icons.verified_user_rounded,
                color: Colors.black,
                opticalSize: 2.0,
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
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 2.0,
                vertical: 0.0,
              ),
              label: Text(
                Helper().roleToRoleName(officialsData[index]["userRole"]),
                style: GoogleFonts.raleway(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
        children: [
          const Divider(
            thickness: 1,
          ),
          ListTile(
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
                  return _profileWidget(index);
                },
              );
            },
            leading: const Icon(
              Icons.account_circle_rounded,
            ),
            title: Text(
              "View Profile",
              style: GoogleFonts.raleway(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          if (officialsData[index]["userAccountStatus"] == "A") ...[
            ListTile(
              onTap: () {
                _toggleStatus(index).then((value) {
                  if (value == "-1" || value == "-2" || value == "-3") {
                    return;
                  }
                });
              },
              leading: Icon(
                Icons.gpp_bad_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                "Deactivate Account",
                style: GoogleFonts.raleway(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ] else ...[
            ListTile(
              onTap: () {
                _toggleStatus(index).then((value) {
                  if (value == "-1" || value == "-2" || value == "-3") {
                    return;
                  }
                });
              },
              leading: const Icon(
                Icons.verified_rounded,
                color: Colors.greenAccent,
              ),
              title: Text(
                "Activate Account",
                style: GoogleFonts.raleway(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ],
          const SizedBox(
            height: 8,
          ),
        ],
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
                        "Officials",
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
                        if (officialsData.isEmpty) ...[
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
                                  "No officials added by you yet. Please add an official by clicking the button below.",
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
                                              return AdminNewOfficialScreen(
                                                userData: widget.userData,
                                              );
                                            case "H":
                                              return HsHeadNewOfficialScreen(
                                                  userData: widget.userData);
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
                                    "Add Official",
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
                            itemCount: officialsData.length,
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
