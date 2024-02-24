import 'package:ansan/admin/patients/patient_screen.dart';
import 'package:ansan/doctor/patients/patient_screen.dart';
import 'package:ansan/frontline_worker/patients/patient_screen.dart';
import 'package:ansan/hshead/patients/patient_screen.dart';
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

class NewPatientScreen extends StatefulWidget {
  const NewPatientScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<NewPatientScreen> createState() => _NewPatientScreenState();
}

class _NewPatientScreenState extends State<NewPatientScreen> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  String? _gender;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;

  Future<String> _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final db = FirebaseFirestore.instance;

      // Check if user with aadhar number or phone number already exists with single query

      final QuerySnapshot<Map<String, dynamic>> theQuery = await db
          .collection("userData")
          .where(
            Filter(
              "userAadhar",
              isEqualTo: _aadharController.text.trim(),
            ),
          )
          .get();

      if (theQuery.docs.isNotEmpty) {
        showToast("User with same Aadhar or Email already exists.");
        return "-2";
      }

      debugPrint({
        "userId": "",
        "userName": _userNameController.text,
        "userEmail": _userEmailController.text,
        "phoneNumber": _phoneNumberController.text,
        "userDob": _dobController.text,
        "userGender": _gender,
        "userAadhar": _aadharController.text,
        "userAddress": _addressController.text,
        "userRole": "U",
        "userAccountStatus": "A",
        "createdAt": FieldValue.serverTimestamp(),
        "lastUpdatedAt": FieldValue.serverTimestamp(),
        "numberOfFamilyMembers": 0,
        "numberOfTests": 0, // collection within userData
        "numberOfQuestionnairesTaken": 0, // collection within userData
        "addedBy": FirebaseAuth.instance.currentUser!.uid,
      }.toString());

      // Add user to Cloud Firestore

      final Map<String, dynamic> userData = {
        "userId": "",
        "userName": _userNameController.text,
        "userEmail": _userEmailController.text,
        "phoneNumber": _phoneNumberController.text,
        "userDob": _dobController.text,
        "userGender": _gender,
        "userAadhar": _aadharController.text,
        "userAddress": _addressController.text,
        "userRole": "U",
        "userAccountStatus": "A",
        "createdAt": FieldValue.serverTimestamp(),
        "lastUpdatedAt": FieldValue.serverTimestamp(),
        "numberOfFamilyMembers": 0,
        "numberOfTests": 0, // collection within userData
        "numberOfQuestionnairesTaken": 0, // collection within userData
        "addedBy": FirebaseAuth.instance.currentUser!.uid,
      };

      String? insertId = await db
          .collection("userData")
          .add(userData)
          .then((value) => value.id)
          .onError((error, stackTrace) {
        debugPrint("Error adding user to Cloud Firestore: $error");
        return "-1";
      });

      if (insertId == "-1") {
        showToast("Something went wrong. Please try again later.");
        return "-1";
      }

      await db.collection("userData").doc(insertId).set({
        "userId": insertId,
      }, SetOptions(merge: true)).onError((error, stackTrace) {
        debugPrint("Error updating user to Cloud Firestore: $error");
      });

      return insertId;
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.code}");
      switch (e.code) {
        case "weak-password":
          showToast("Password is too weak. Please use a stronger password.");
          return "-3";
        case "invalid-email":
          showToast("Invalid Email ID. Please check patient's Email ID.");
          return "-3";
        case "email-already-in-use":
          showToast(
              "Email ID is already in use. Please use a different Email ID.");
          return "-3";
        default:
          showToast("Something went wrong. Please try again later.");
          return "-1";
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
                        "New Patient",
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
                    physics: const ClampingScrollPhysics(),
                    primary: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    child: Form(
                      key: _registerFormKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      canPop: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 16.0,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Text(
                              "Optional Fields",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.titleSmall,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(),
                            controller: _userEmailController,
                            validator: DataValidator().nullEmailValidator,
                            decoration: InputDecoration(
                              labelText: "Email ID",
                              prefixIcon: const Icon(Icons.email_rounded),
                              hintText: "Please enter patient's email ID",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              labelStyle: GoogleFonts.poppins(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            style: GoogleFonts.poppins(),
                            controller: _phoneNumberController,
                            validator: DataValidator().nullPhoneNumberValidator,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              prefixIcon: const Icon(Icons.phone_rounded),
                              hintText: "Please enter patient's phone number",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              labelStyle: GoogleFonts.poppins(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 16.0,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Text(
                              "Mandatory Fields",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.titleSmall,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            style: GoogleFonts.poppins(),
                            controller: _userNameController,
                            validator: DataValidator().nameValidator,
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              prefixIcon: const Icon(Icons.person_rounded),
                              hintText: "Please enter patient's full name",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
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
                              hintText: "Select patient's DOB.",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
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
                              hintText: "Please enter patient's Aadhar Number",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              labelStyle: GoogleFonts.poppins(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            maxLines: null,
                            style: GoogleFonts.poppins(),
                            controller: _addressController,
                            validator: DataValidator().addressValidator,
                            decoration: InputDecoration(
                              labelText: "Address",
                              prefixIcon: const Icon(Icons.location_on_rounded),
                              hintText: "Please enter patient's address",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer,
                                ),
                              ),
                              labelStyle: GoogleFonts.poppins(),
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_registerFormKey.currentState!.validate()) {
                                  _registerUser().then((value) {
                                    if (value == "-1" ||
                                        value == "-2" ||
                                        value == "-3" ||
                                        value == "-4") {
                                      return;
                                    }

                                    showToast(
                                        "Patient Registered Successfully.");
                                    Navigator.of(context).pushReplacement(
                                      CupertinoPageRoute(builder: (context) {
                                        switch (widget.userData["userRole"]) {
                                          case "A":
                                            return AdminPatientScreen(
                                              userData: widget.userData,
                                              patientId: value,
                                            );
                                          case "D":
                                            return DoctorPatientScreen(
                                              userData: widget.userData,
                                              patientId: value,
                                            );
                                          case "H":
                                            return HsHeadPatientScreen(
                                              userData: widget.userData,
                                              patientId: value,
                                            );
                                          case "F":
                                            return FrontlineWorkerPatientScreen(
                                              userData: widget.userData,
                                              patientId: value,
                                            );
                                          default:
                                            return const WelcomeScreen();
                                        }
                                      }),
                                    );
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 16.0,
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              child: Text(
                                "New Patient",
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.titleLarge,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
                  ),
                ),
              ],
            ),
    );
  }
}
