import 'package:ansan/user/home_screen.dart';
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

class UserEditProfileScreen extends StatefulWidget {
  const UserEditProfileScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<UserEditProfileScreen> createState() => _UserEditProfileScreenState();
}

class _UserEditProfileScreenState extends State<UserEditProfileScreen> {
  final GlobalKey<FormState> _editProfileFormKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  String? _gender;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _isLoading = false;
      _userNameController.text = widget.userData["userName"];
      _userEmailController.text = widget.userData["userEmail"];
      _phoneNumberController.text = widget.userData["phoneNumber"];
      _dobController.text = widget.userData["userDob"];
      _gender = widget.userData["userGender"];
      _aadharController.text = widget.userData["userAadhar"];
      _addressController.text = widget.userData["userAddress"];
    });
  }

  Future<String> _updateProfile() async {
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
                "userEmail",
                isNotEqualTo: FirebaseAuth.instance.currentUser?.email,
              ),
              Filter.or(
                Filter(
                  "userAadhar",
                  isEqualTo: _aadharController.text.trim(),
                ),
                Filter(
                  "phoneNumber",
                  isEqualTo: _phoneNumberController.text.trim(),
                ),
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
          "userAddress": _addressController.text,
          "lastUpdatedAt": FieldValue.serverTimestamp(),
        };

        await db
            .collection("userData")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set(userData, SetOptions(merge: true))
            .onError((error, stackTrace) {
          debugPrint("Error updating user profile in Cloud Firestore: $error");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _isLoading == true
          ? const LoadingScreen()
          : CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  floating: true,
                  snap: true,
                  pinned: true,
                  centerTitle: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 8.0,
                    ),
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        "Edit Profile",
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
                      key: _editProfileFormKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      canPop: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(),
                            controller: _userEmailController,
                            enabled: false,
                            validator: DataValidator().emailValidator,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            style: GoogleFonts.poppins(),
                            controller: _phoneNumberController,
                            enabled: false,
                            validator: DataValidator().phoneNumberValidator,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              prefixIcon: const Icon(Icons.email_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.poppins(),
                            controller: _aadharController,
                            enabled: false,
                            validator: DataValidator().aadharNumberValidator,
                            decoration: InputDecoration(
                              labelText: "Aadhar Number",
                              prefixIcon: const Icon(Icons.email_rounded),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
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
                              hintText: "Select your DOB.",
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
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            maxLines: null,
                            style: GoogleFonts.poppins(),
                            controller: _addressController,
                            validator: DataValidator().addressValidator,
                            decoration: InputDecoration(
                              labelText: "Address",
                              prefixIcon: const Icon(Icons.location_on_rounded),
                              hintText: "Please enter your address",
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
                                if (_editProfileFormKey.currentState!
                                    .validate()) {
                                  _updateProfile().then((value) {
                                    if (value == "-1" ||
                                        value == "-2" ||
                                        value == "-3" ||
                                        value == "-4") {
                                      return;
                                    }

                                    showToast(
                                        "User Profile Updated Successfully.");

                                    Navigator.of(context).pushAndRemoveUntil(
                                        CupertinoPageRoute(builder: (context) {
                                      return const UserHomeScreen();
                                    }), (route) => false);
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
                                "Update",
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
