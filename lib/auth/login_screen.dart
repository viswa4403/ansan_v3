import 'package:ansan/admin/home_screen.dart';
import 'package:ansan/auth/register_screen.dart';
import 'package:ansan/doctor/home_screen.dart';
import 'package:ansan/frontline_worker/home_screen.dart';
import 'package:ansan/hshead/home_screen.dart';
import 'package:ansan/user/home_screen.dart';
import 'package:ansan/util/data_validator.dart';
import 'package:ansan/util/helper.dart';
import 'package:ansan/util/loading_screen.dart';
import 'package:ansan/util/toast_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();

  bool _isLoading = false;

  bool _showPassword = true;

  Future<String> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _userEmailController.text.trim(),
        password: Helper().sha256Hash(_userPasswordController.text),
      );

      if (credential.user != null) {
        // Get UserData from Firestore
        final db = FirebaseFirestore.instance;
        final userData =
            await db.collection("userData").doc(credential.user!.uid).get();

        if (userData.exists) {
          return userData["userRole"];
        }

        showToast("You are not registered yet. Please sign up first.");
        return "-4";
      }

      debugPrint("User is null");

      return "-2";
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.code}");
      switch (e.code) {
        case "invalid-credential":
          showToast(
              "Invalid Credentials. If you are not registered, please sign up.");
          return "-3";
        case "invalid-email":
          showToast("Invalid Email ID. Please check your Email ID.");
          return "-3";
        default:
          showToast("Something went wrong. Please try again later.");
          return "-1";
      }
    } catch (e) {
      showToast("Something went wrong. Please try again later.");
      return "-1";
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                  expandedHeight: MediaQuery.of(context).size.height * 0.24,
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
                        "Login",
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
                      key: _loginFormKey,
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
                              "Please enter your registered Email ID and Password to login to your ANSAN account.",
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
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(),
                            controller: _userEmailController,
                            validator: DataValidator().emailValidator,
                            decoration: InputDecoration(
                              labelText: "Email ID",
                              prefixIcon: const Icon(Icons.badge_rounded),
                              hintText: "Please enter your email ID",
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
                            keyboardType: TextInputType.visiblePassword,
                            style: GoogleFonts.poppins(),
                            controller: _userPasswordController,
                            validator: DataValidator().passwordValidator,
                            obscureText: _showPassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.password_rounded),
                              hintText: "Please enter your password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                                icon: Icon(
                                  _showPassword == false
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                ),
                              ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    CupertinoPageRoute(builder: (context) {
                                      return const RegisterScreen();
                                    }),
                                  );
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  overlayColor: MaterialStateProperty.all(
                                    Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.titleSmall,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: Implement Forgot Password
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  overlayColor: MaterialStateProperty.all(
                                    Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  "Forgot Password",
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.titleSmall,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_loginFormKey.currentState!.validate()) {
                                  _loginUser().then((value) {
                                    if (value == "-1" ||
                                        value == "-2" ||
                                        value == "-3" ||
                                        value == "-4") {
                                      return;
                                    }

                                    switch (value) {
                                      case "U":
                                        Navigator.of(context).pushAndRemoveUntil(
                                          CupertinoPageRoute(
                                              builder: (context) {
                                            return const UserHomeScreen();
                                          }),
                                          (route) => false,
                                        );
                                        break;
                                      case "A":
                                        Navigator.of(context).pushAndRemoveUntil(
                                          CupertinoPageRoute(
                                              builder: (context) {
                                                return const AdminHomeScreen();
                                              }),
                                              (route) => false,
                                        );
                                      case "H":
                                        Navigator.of(context).pushAndRemoveUntil(
                                          CupertinoPageRoute(
                                              builder: (context) {
                                                return const HsHeadHomeScreen();
                                              }),
                                              (route) => false,
                                        );
                                      case "D":
                                        Navigator.of(context).pushAndRemoveUntil(
                                          CupertinoPageRoute(
                                              builder: (context) {
                                                return const DoctorHomeScreen();
                                              }),
                                              (route) => false,
                                        );
                                      case "F":
                                        Navigator.of(context).pushAndRemoveUntil(
                                          CupertinoPageRoute(
                                              builder: (context) {
                                                return const FrontlineWorkerHomeScreen();
                                              }),
                                              (route) => false,
                                        );
                                      default:
                                        break;
                                    }
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
                                "Sign In",
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
