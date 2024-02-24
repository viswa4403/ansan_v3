import 'package:ansan/admin/patients/all_patients_screen.dart';
import 'package:ansan/admin/patients/new_patient_screen.dart';
import 'package:ansan/admin/patients/patient_screen.dart';
import 'package:ansan/doctor/patients/patient_screen.dart';
import 'package:ansan/frontline_worker/patients/all_patients_screen.dart';
import 'package:ansan/frontline_worker/patients/new_patient_screen.dart';
import 'package:ansan/frontline_worker/patients/patient_screen.dart';
import 'package:ansan/hshead/patients/all_patients_screen.dart';
import 'package:ansan/hshead/patients/new_patient_screen.dart';
import 'package:ansan/hshead/patients/patient_screen.dart';
import 'package:ansan/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientsComponent extends StatefulWidget {
  const PatientsComponent({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  State<PatientsComponent> createState() => _PatientsComponentState();
}

class _PatientsComponentState extends State<PatientsComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
      ),
      child: Column(
        children: [
          Text(
            "Manage Patients",
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
          Form(
            key: _formKey,
            child: TextFormField(
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (context) {
                    switch (widget.userData["userRole"]) {
                      case "A":
                        return AdminPatientScreen(
                          userData: widget.userData,
                          patientId: _searchController.text.trim(),
                        );
                      case "H":
                        return HsHeadPatientScreen(
                          userData: widget.userData,
                          patientId: _searchController.text.trim(),
                        );
                      case "D":
                        return DoctorPatientScreen(
                          userData: widget.userData,
                          patientId: _searchController.text.trim(),
                        );
                      case "F":
                        return FrontlineWorkerPatientScreen(
                          userData: widget.userData,
                          patientId: _searchController.text.trim(),
                        );
                      default:
                        return const WelcomeScreen();
                    }
                  }));
                }
              },
              keyboardType: TextInputType.name,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.titleSmall,
              ),
              controller: _searchController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a valid Patient ID";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Search patient by Patient ID",
                suffixIcon: IconButton(
                    icon: Icon(Icons.search_rounded,
                        color: Theme.of(context).colorScheme.primary),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context)
                            .push(CupertinoPageRoute(builder: (context) {
                          switch (widget.userData["userRole"]) {
                            case "A":
                              return AdminPatientScreen(
                                userData: widget.userData,
                                patientId: _searchController.text.trim(),
                              );
                            case "H":
                              return HsHeadPatientScreen(
                                userData: widget.userData,
                                patientId: _searchController.text.trim(),
                              );
                            case "D":
                              return DoctorPatientScreen(
                                userData: widget.userData,
                                patientId: _searchController.text.trim(),
                              );
                            case "F":
                              return FrontlineWorkerPatientScreen(
                                userData: widget.userData,
                                patientId: _searchController.text.trim(),
                              );
                            default:
                              return const WelcomeScreen();
                          }
                        }));
                      }
                    }),
                hintText: "Please enter the Patient ID",
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
            ),
          ),
          if (widget.userData["userRole"] != "D") ...[
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (context) {
                    switch (widget.userData["userRole"]) {
                      case "A":
                        return AdminNewPatientScreen(
                          userData: widget.userData,
                        );
                      case "H":
                        return HsHeadNewPatientScreen(
                          userData: widget.userData,
                        );
                      case "F":
                        return FrontlineWorkerNewPatientScreen(
                          userData: widget.userData,
                        );
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
                  Icons.medical_services_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  "New Patient",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.titleSmall,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (context) {
                    switch (widget.userData["userRole"]) {
                      case "A":
                        return AdminAllPatientsScreen(
                          userData: widget.userData,
                        );
                      case "H":
                        return HsHeadAllPatientsScreen(
                          userData: widget.userData,
                        );
                      case "F":
                        return FrontlineWorkerAllPatientsScreen(
                          userData: widget.userData,
                        );
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
                  Icons.remove_red_eye_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  "View Patients added by you",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.titleSmall,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
