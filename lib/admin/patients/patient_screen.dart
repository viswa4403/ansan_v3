import 'package:ansan/util/patients/patient_screen.dart';
import 'package:flutter/material.dart';

class AdminPatientScreen extends StatefulWidget {
  const AdminPatientScreen({super.key, required this.userData, required this.patientId});

  final Map<String, dynamic> userData;
  final String patientId;

  @override
  State<AdminPatientScreen> createState() => _AdminPatientScreenState();
}

class _AdminPatientScreenState extends State<AdminPatientScreen> {
  @override
  Widget build(BuildContext context) {
    return ViewPatientScreen(patientId: widget.patientId, userData: widget.userData);
  }
}
