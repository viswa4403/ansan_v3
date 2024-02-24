import 'package:ansan/user/family_member/all_history_screen.dart';
import 'package:ansan/user/family_member/new_family_member_screen.dart';
import 'package:ansan/user/family_member/patient_take_test.dart';
import 'package:ansan/user/family_member/patient_test_results.dart';
import 'package:ansan/user/family_member/the_form_screen.dart';
import 'package:ansan/util/data_validator.dart';
import 'package:ansan/util/loading_screen.dart';
import 'package:ansan/util/toast_message.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserFamilyMembersScreen extends StatefulWidget {
  const UserFamilyMembersScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<UserFamilyMembersScreen> createState() =>
      _UserFamilyMembersScreenState();
}

class _UserFamilyMembersScreenState extends State<UserFamilyMembersScreen> {
  List<Map<String, dynamic>> familyMemberData = [];

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
          .where(Filter("addedBy",
              isEqualTo: FirebaseAuth.instance.currentUser!.uid))
          .get()
          .then((querySnapshot) {
        setState(() {
          familyMemberData = querySnapshot.docs.map((e) => e.data()).toList();
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _gender;
  final TextEditingController _aadharController = TextEditingController();

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
        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(_userNameController.text);

        final Map<String, dynamic> userData = {
          "userAccountStatus":
              familyMemberData[index]["userAccountStatus"] == "A" ? "I" : "A",
        };

        await db
            .collection("userData")
            .doc(familyMemberData[index]["userId"])
            .set(userData, SetOptions(merge: true))
            .onError((error, stackTrace) {
          debugPrint("Error updating user profile in Cloud Firestore: $error");
        });

        if (familyMemberData[index]["userAccountStatus"] == "A") {
          showToast("Account deactivated successfully.");
        } else {
          showToast("Account activated successfully.");
        }

        setState(() {
          familyMemberData[index]["userAccountStatus"] =
              familyMemberData[index]["userAccountStatus"] == "A" ? "I" : "A";
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

  Future<String> _updateFamilyMemberData(int index) async {
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

      // Check if user with aadhar number or phone number already exists with single query
      final QuerySnapshot<Map<String, dynamic>> theQuery = await db
          .collection("userData")
          .where(
            Filter.and(
              Filter(
                "userId",
                isNotEqualTo: familyMemberData[index]["userId"],
              ),
              Filter(
                "userAadhar",
                isEqualTo: _aadharController.text.trim(),
              ),
            ),
          )
          .get();

      if (theQuery.docs.isNotEmpty) {
        showToast("User with same Aadhar or Phone Number already exists.");
        return "-2";
      }

      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(_userNameController.text);

        final Map<String, dynamic> userData = {
          "userName": _userNameController.text,
          "userDob": _dobController.text,
          "userGender": _gender,
          "userAadhar": _aadharController.text,
          "lastUpdatedAt": FieldValue.serverTimestamp(),
        };

        await db
            .collection("userData")
            .doc(familyMemberData[index]["userId"])
            .set(userData, SetOptions(merge: true))
            .onError((error, stackTrace) {
          debugPrint("Error updating user profile in Cloud Firestore: $error");
        });

        showToast("Profile updated successfully.");

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

  Widget _editProfileWidget(int index) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 32.0,
      ),
      child: Form(
        key: _formKey,
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
                  "Edit Profile",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.habibi(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              style: GoogleFonts.poppins(),
              controller: _userNameController,
              validator: DataValidator().nameValidator,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: const Icon(Icons.person_rounded),
                hintText: "Please enter your full name",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                labelStyle: GoogleFonts.poppins(),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              keyboardType: TextInputType.datetime,
              style: GoogleFonts.sourceCodePro(),
              controller: _dobController,
              validator: DataValidator().dobValidator,
              decoration: InputDecoration(
                labelText: "DOB",
                prefixIcon: const Icon(Icons.date_range),
                hintText: "Select your DOB.",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onErrorContainer),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onErrorContainer),
                ),
                labelStyle: GoogleFonts.poppins(),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    _dobController.text = formattedDate;
                  });
                } else {}
              },
            ),
            const SizedBox(
              height: 16,
            ),
            DropdownButtonFormField(
              value: _gender,
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem(
                  value: "M",
                  child: Text(
                    "Male",
                    style: GoogleFonts.poppins(),
                  ),
                ),
                DropdownMenuItem(
                  value: "F",
                  child: Text(
                    "Female",
                    style: GoogleFonts.poppins(),
                  ),
                ),
                DropdownMenuItem(
                  value: "O",
                  child: Text(
                    "Prefer not to say",
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ],
              validator: DataValidator().genderValidator,
              decoration: InputDecoration(
                labelText: "Gender",
                prefixIcon: const Icon(Icons.person_pin_outlined),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onErrorContainer),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onErrorContainer),
                ),
                labelStyle: GoogleFonts.poppins(),
              ),
              onChanged: (String? value) {
                setState(() {
                  _gender = value;
                });
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(),
              controller: _aadharController,
              validator: DataValidator().aadharNumberValidator,
              decoration: InputDecoration(
                labelText: "Aadhar Number",
                prefixIcon: const Icon(Icons.badge_rounded),
                hintText: "Please enter your Aadhar Number",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                labelStyle: GoogleFonts.poppins(),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateFamilyMemberData(index).then((value) {
                      if (value == "-1" ||
                          value == "-2" ||
                          value == "-3" ||
                          value == "-4") {
                        return;
                      }

                      Navigator.of(context).pop();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 16.0,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: Text(
                  "Update",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.titleLarge,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 48,
            ),
          ],
        ),
      ),
    );
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
            height: 32,
          ),
          TextField(
            controller: TextEditingController(
                text: familyMemberData[index]["userName"]),
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
                TextEditingController(text: familyMemberData[index]["userDob"]),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Date of Birth",
              prefixIcon: const Icon(Icons.calendar_today_rounded),
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
              text: familyMemberData[index]["userGender"] == "M"
                  ? "Male"
                  : familyMemberData[index]["userGender"] == "F"
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
                text: familyMemberData[index]["userAadhar"]),
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Aadhar",
              prefixIcon: const Icon(Icons.badge_rounded),
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
          "${familyMemberData[index]["userName"]}",
          style: GoogleFonts.raleway(
            textStyle: Theme.of(context).textTheme.titleMedium,
            color: Theme.of(context).colorScheme.secondary,
          ),
          textAlign: TextAlign.start,
        ),
        subtitle: Align(
          alignment: Alignment.centerLeft,
          child: Chip(
            avatar: familyMemberData[index]['userAccountStatus'] == "A"
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
              familyMemberData[index]["userAccountStatus"] == "A"
                  ? "Active"
                  : "Inactive",
              style: GoogleFonts.raleway(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            backgroundColor: familyMemberData[index]["userAccountStatus"] == "A"
                ? Colors.greenAccent
                : Theme.of(context).colorScheme.error,
          ),
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
          ListTile(
            onTap: () {
              setState(() {
                _userNameController.text = familyMemberData[index]["userName"];
                _dobController.text = familyMemberData[index]["userDob"];
                _aadharController.text = familyMemberData[index]["userAadhar"];
                _gender = familyMemberData[index]["userGender"];
              });

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
                  return _editProfileWidget(index);
                },
              );
            },
            leading: const Icon(
              Icons.card_membership_rounded,
            ),
            title: Text(
              "Edit Profile",
              style: GoogleFonts.raleway(
                textStyle: Theme.of(context).textTheme.bodyMedium,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          if (familyMemberData[index]["userAccountStatus"] == "A") ...[
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
          if (familyMemberData[index]["numberOfQuestionnairesTaken"] > 0) ...[
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) {
                    return FamilyMemberAllMedicalHistory(familyMemberData: familyMemberData[index], userData: widget.userData,);
                  })
                );
              },
              leading: const Icon(
                Icons.medication_rounded,
              ),
              title: Text(
                "View Medical History",
                style: GoogleFonts.raleway(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                // TODO: Update Medical History

                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) {
                    return FamilyMemberQuestionnaireForm(familyMemberId: familyMemberData[index]["userId"], familyMemberName: familyMemberData[index]["userName"]);
                  })
                );

              },
              leading: const Icon(
                Icons.edit_rounded,
              ),
              title: Text(
                "Update Medical History",
                style: GoogleFonts.raleway(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ] else ...[
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) {
                    return FamilyMemberQuestionnaireForm(familyMemberId: familyMemberData[index]["userId"], familyMemberName: familyMemberData[index]["userName"]);
                  })
                );
              },
              leading: const Icon(
                Icons.medical_information_rounded,
                color: Colors.tealAccent,
              ),
              title: Text(
                "Fill up Medical History",
                style: GoogleFonts.raleway(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: Colors.tealAccent,
                ),
              ),
            ),
          ],
          if (familyMemberData[index]["numberOfQuestionnairesTaken"] > 0) ...[
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context) {
                      return FamilyMemberPatientTakeTest(userData: widget.userData, patientId: familyMemberData[index]["userId"]);
                    })
                );
              },
              leading: const Icon(
                Icons.medical_information_rounded,
                color: Colors.tealAccent,
              ),
              title: Text(
                "Take Glaucoma Test",
                style: GoogleFonts.raleway(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: Colors.tealAccent,
                ),
              ),
            ),
            if (familyMemberData[index]['numberOfTests'] > 0) ...[
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(builder: (context) {
                        return FamilyMemberPatientResults(userData: widget.userData, patientData: familyMemberData[index]);
                      })
                  );
                },
                leading: const Icon(
                  Icons.medical_information_rounded,
                  color: Colors.tealAccent,
                ),
                title: Text(
                  "View Test Results",
                  style: GoogleFonts.raleway(
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    fontWeight: FontWeight.w600,
                    color: Colors.tealAccent,
                  ),
                ),
              ),
            ],
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
                        "Family Members",
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
                        if (familyMemberData.isEmpty) ...[
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
                                  "No family members added yet. Please add a family member by clicking the button below.",
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
                                            userData: widget.userData,
                                          );
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
                                    "Add Family Member",
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
                            itemCount: familyMemberData.length,
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
