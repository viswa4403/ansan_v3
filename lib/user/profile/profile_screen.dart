import 'package:ansan/user/home_screen.dart';
import 'package:ansan/user/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

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
                            return UserEditProfileScreen(userData: widget.userData);
                          },
                        );
                      },
                      icon: const Icon(Icons.edit_rounded),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return const UserHomeScreen();
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
                          controller:
                              TextEditingController(text: widget.userData["userName"]),
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
                          controller:
                              TextEditingController(text: widget.userData["userDob"]),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Date of Birth",
                            prefixIcon:
                                const Icon(Icons.calendar_today_rounded),
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
                        TextField(
                          controller: TextEditingController(
                              text: widget.userData["userAadhar"]),
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
                        TextField(
                          maxLines: null,
                          controller: TextEditingController(
                              text: widget.userData["userAddress"]),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Address",
                            prefixIcon: const Icon(Icons.home_rounded),
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
