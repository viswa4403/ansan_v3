import 'package:ansan/util/patients/patient_screen.dart';
import 'package:flutter/material.dart';

class DoctorPatientScreen extends StatefulWidget {
  const DoctorPatientScreen({super.key, required this.userData, required this.patientId});

  final Map<String, dynamic> userData;
  final String patientId;

  @override
  State<DoctorPatientScreen> createState() => _DoctorPatientScreenState();
}

class _DoctorPatientScreenState extends State<DoctorPatientScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewPatientScreen(patientId: widget.patientId, userData: widget.userData);
  }
}
