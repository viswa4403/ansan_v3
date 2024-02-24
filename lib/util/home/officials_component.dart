import 'package:ansan/admin/officials/all_officials_screen.dart';
import 'package:ansan/admin/officials/new_official_screen.dart';
import 'package:ansan/hshead/officials/all_officials_screen.dart';
import 'package:ansan/hshead/officials/new_official_screen.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OfficialsComponent extends StatelessWidget {
  const OfficialsComponent({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.99,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Manage Officials",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.titleLarge,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (context) {
                    switch (userData["userRole"]) {
                      case "A":
                        return AdminAllOfficialsScreen(userData: userData);
                      case "H":
                        return HsHeadAllOfficialsScreen(userData: userData);
                      default:
                        return const WelcomeScreen();
                    }
                  }));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                icon: Icon(
                  Icons.temple_hindu_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  "View Officials",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.titleSmall,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (context) {
                    switch (userData["userRole"]) {
                      case "A":
                        return AdminNewOfficialScreen(userData: userData);
                      case "H":
                        return HsHeadNewOfficialScreen(userData: userData);
                      default:
                        return const WelcomeScreen();
                    }
                  }));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                icon: Icon(
                  Icons.add_circle_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  "New Official",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.titleSmall,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
