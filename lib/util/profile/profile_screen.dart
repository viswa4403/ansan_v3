import 'package:ansan/admin/home_screen.dart';
import 'package:ansan/doctor/home_screen.dart';
import 'package:ansan/frontline_worker/home_screen.dart';
import 'package:ansan/hshead/home_screen.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
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
            actions: [
              IconButton(
                onPressed: () {
                  // showModalBottomSheet(
                  //   context: context,
                  //   shape: const RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.only(
                  //       topLeft: Radius.circular(16.0),
                  //       topRight: Radius.circular(16.0),
                  //     ),
                  //   ),
                  //   constraints: BoxConstraints(
                  //     minWidth: MediaQuery.of(context).size.width,
                  //   ),
                  //   enableDrag: true,
                  //   useSafeArea: true,
                  //   isDismissible: true,
                  //   showDragHandle: true,
                  //   isScrollControlled: true,
                  //   builder: (context) {
                  //
                  //   },
                  // );
                },
                icon: const Icon(Icons.edit_rounded),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        switch (widget.userData["userRole"]) {
                          case "A":
                            return const AdminHomeScreen();
                          case "H":
                            return const HsHeadHomeScreen();
                          case "D":
                            return const DoctorHomeScreen();
                          case "F":
                            return const FrontlineWorkerHomeScreen();
                          default:
                            return const WelcomeScreen();
                        }
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.home_rounded),
              ),
            ],
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
                  "Profile",
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
                vertical: 32.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: TextEditingController(
                        text: widget.userData["userName"]),
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
                    controller: TextEditingController(
                        text: widget.userData["userEmail"]),
                    readOnly: true,
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
                  TextField(
                    controller: TextEditingController(
                      text: widget.userData["userGender"] == "M"
                          ? "Male"
                          : widget.userData["userGender"] == "F"
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
                        text: widget.userData["phoneNumber"]),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Phone",
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
            ),
          ),
        ],
      ),
    );
  }
}
