import 'package:ansan/util/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenWelcomeContainer extends StatelessWidget {
  const HomeScreenWelcomeContainer({
    super.key,
    required this.userName,
    required this.userRole,
  });

  final String userName, userRole;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.64,
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        color:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Text(
              "Welcome",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.titleMedium,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Text(
              userName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.titleLarge,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          if (userRole != "U") ...[
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 8,
            ),
            Chip(
              padding: const EdgeInsets.all(8.0),
              avatar: const Icon(
                Icons.security_rounded,
              ),
              side: const BorderSide(
                color: Colors.black,
                width: 2,
              ),
              elevation: 1,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              label: Text(
                Helper().roleToRoleName(userRole),
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.titleSmall,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              backgroundColor: Colors.greenAccent,
            ),
          ],
        ],
      ),
    );
  }
}
