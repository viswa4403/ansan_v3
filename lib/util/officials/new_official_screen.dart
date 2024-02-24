import 'package:ansan/util/data_validator.dart';
import 'package:ansan/util/loading_screen.dart';
import 'package:ansan/util/toast_message.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewOfficialScreen extends StatefulWidget {
  const NewOfficialScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<NewOfficialScreen> createState() => _NewOfficialScreenState();
}

class _NewOfficialScreenState extends State<NewOfficialScreen> {
  final GlobalKey<FormState> _newOfficialFormKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  String? _gender, _userRole;
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isLoading = false;

  Future<String> _addOfficial() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final db = FirebaseFirestore.instance;

      // Check if user with aadhar number or phone number already exists with single query

      final QuerySnapshot<Map<String, dynamic>> theQuery = await db
          .collection("userData")
          .where(
            Filter.or(
              Filter(
                "userEmail",
                isEqualTo: _userEmailController.text,
              ),
              Filter(
                "phoneNumber",
                isEqualTo: _phoneNumberController.text,
              ),
            ),
          )
          .get();

      if (theQuery.docs.isNotEmpty) {
        showToast("User with same UserEmail or phone number already exists.");
        return "-2";
      }

      debugPrint({
        "userId": "",
        "userName": _userNameController.text.trim(),
        "userEmail": _userEmailController.text.trim(),
        "phoneNumber": _phoneNumberController.text.trim(),
        "userGender": _gender,
        "userRole": _userRole,
        "userAccountStatus": "A",
        "createdAt": FieldValue.serverTimestamp(),
        "lastUpdatedAt": FieldValue.serverTimestamp(),
        "addedBy": widget.userData["userId"],
      }.toString());

      // register user with email and password. password format: "userEmail|phoneNumber"
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _userEmailController.text,
        password: "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8",
      );

      if (credential.user == null) {
        showToast("Something went wrong. Please try again later.");
        return "-3";
      }

      // Add user to Cloud Firestore

      final Map<String, dynamic> userData = {
        "userId": credential.user!.uid,
        "userName": _userNameController.text,
        "userEmail": _userEmailController.text,
        "phoneNumber": _phoneNumberController.text,
        "userGender": _gender,
        "userRole": _userRole,
        "userAccountStatus": "A",
        "createdAt": FieldValue.serverTimestamp(),
        "lastUpdatedAt": FieldValue.serverTimestamp(),
        "addedBy": widget.userData["userId"],
      };

      await db.collection("userData").doc(credential.user!.uid).set(userData);

      return "1";
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
                        "New Official",
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
                      key: _newOfficialFormKey,
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
                              "Please fill in official's details to register them to ANSAN.",
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            style: GoogleFonts.poppins(),
                            controller: _userNameController,
                            validator: DataValidator().nameValidator,
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              prefixIcon: const Icon(Icons.person_rounded),
                              hintText: "Please official's full name",
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
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(),
                            controller: _userEmailController,
                            validator: DataValidator().emailValidator,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email_rounded),
                              hintText: "Enter official's email",
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
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          DropdownButtonFormField(
                            items: <DropdownMenuItem<String>>[
                              if (widget.userData["userRole"] == "A") ...[
                                DropdownMenuItem(
                                  value: "H",
                                  child: Text(
                                    "Hospital Head",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              ],
                              if (widget.userData["userRole"] == "H" ||
                                  widget.userData["userRole"] == "A") ...[
                                DropdownMenuItem(
                                  value: "D",
                                  child: Text(
                                    "Doctor",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "F",
                                  child: Text(
                                    "Frontline Worker",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              ],
                            ],
                            validator: DataValidator().roleValidator,
                            decoration: InputDecoration(
                              labelText: "Role",
                              prefixIcon: const Icon(Icons.insights_rounded),
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
                            value: _userRole,
                            onChanged: (String? value) {
                              setState(() {
                                _userRole = value;
                              });
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
                            value: _gender,
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
                            controller: _phoneNumberController,
                            validator: DataValidator().phoneNumberValidator,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              prefixIcon: const Icon(Icons.badge_rounded),
                              hintText: "Please enter official's phone Number",
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
                            height: 24,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_newOfficialFormKey.currentState!
                                    .validate()) {
                                  _addOfficial().then((value) {
                                    if (value == "-1" ||
                                        value == "-2" ||
                                        value == "-3" ||
                                        value == "-4") {
                                      return;
                                    }

                                    showToast("Official added Successfully.");

                                    showToast("Please login again. Thank you.");

                                    Navigator.of(context).pushAndRemoveUntil(
                                      CupertinoPageRoute(builder: (context) {
                                        return const WelcomeScreen();
                                      }),
                                      (route) => false,
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
                                "Register Official",
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
